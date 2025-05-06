require "thin"
require "io/console"

module Webby
  class Server
    attr_reader :port

    def initialize(port)
      @port = port

      Thin::Logging.silent = true
    end

    def start
      thin_server = Thin::Server.new '127.0.0.1', port
      thin_server.app = app
      thin_server.start
    end

    private

    def app
      Rack::Builder.new do
        map "/" do
          use Rack::Static, urls: {"/" => "index.html"}

          Dir["**/*.html"].each do |e|
            use Rack::Static, urls: {"/#{e.gsub(".html", "")}" => e}
          end

          run Rack::Directory.new("./")
        end
      end
    end
  end
end
