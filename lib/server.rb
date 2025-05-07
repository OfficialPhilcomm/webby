require "thin"
require "io/console"

module Webby
  class Logger
    def initialize(app, logger = nil)
      @app = app
      @logger = logger
    end

    def call(env)
      began_at = clock_time
      request = Rack::Request.new(env)
      status, _headers, _body = response = @app.call(env)

      puts "\n#{request.request_method} #{request.path_info} -> #{status} (#{(clock_time - began_at).round(3)}s)"

      response
    end

    private

    def clock_time
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end

  class Server
    attr_reader :port, :root

    def initialize(port, root)
      @port = port
      @root = root

      Thin::Logging.silent = false
    end

    def start
      puts "Listening on 127.0.0.1:#{port}"
      thin_server = Thin::Server.new '127.0.0.1', port
      thin_server.app = app(root)
      thin_server.start
    end

    private

    def app(root)
      Rack::Builder.new do
        use Webby::Logger
        # use Rack::CommonLogger

        map "/" do
          use Rack::Static, urls: {"/" => File.join(root, "index.html")}

          Dir[File.join(root, "**/*.html")].each do |e|
            use Rack::Static, urls: {"/#{e.gsub(".html", "")}" => e}
          end

          run Rack::Directory.new(root)
        end
      end
    end
  end
end
