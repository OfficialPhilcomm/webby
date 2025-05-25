require "thin"
require "io/console"
require "pastel"
require_relative "logger/thin"
require_relative "logger/webby"

module Webby
  class Server
    attr_reader :port, :root

    def initialize(port, root)
      @port = port
      @root = root

      Webby::Logger::Thin.level = 1
      Thin::Logging.logger = Webby::Logger::Thin
    end

    def start
      thin_server = Thin::Server.new '127.0.0.1', port
      thin_server.app = app(root)
      thin_server.start
    end

    private

    def app(root)
      Rack::Builder.new do
        use Webby::Logger::Webby

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
