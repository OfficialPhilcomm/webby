require "thin"
require "io/console"
require "pastel"

module Webby
  class Logger
    STATUS_CODE_EMOJIS = {
      "200" => "✅",
      "300" => "🔀",
      "304" => "💠",
      "400" => "⛔️",
      "404" => "❓",
      "500" => "💣"
    }

    def initialize(app, logger = nil)
      @app = app
      @logger = logger
    end

    def call(env)
      began_at = clock_time
      request = Rack::Request.new(env)
      status, _headers, _body = response = @app.call(env)

      puts [
        "\n#{request.request_method}",
        request.path_info,
        "->",
        emoji(status),
        colored_status(status.to_s),
        "(#{(clock_time - began_at).round(3)}s)"
      ].join(" ")

      response
    end

    private

    def colored_status(status)
      pastel = Pastel.new

      if status.start_with? "2"
        pastel.green(status)
      elsif status.start_with? "3"
        pastel.yellow(status)
      elsif status.start_with? "4"
        pastel.red(status)
      else
        pastel.blue(status)
      end
    end

    def emoji(status)
      if STATUS_CODE_EMOJIS.has_key? status.to_s
        STATUS_CODE_EMOJIS[status.to_s]
      else
        STATUS_CODE_EMOJIS[((status / 100) * 100).to_s]
      end
    end

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
