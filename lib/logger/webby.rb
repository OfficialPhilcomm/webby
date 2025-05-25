module Webby
  module Logger
    class Webby
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
          "#{time_string}",
          "#{request.request_method}",
          request.path_info,
          "->",
          emoji(status),
          colored_status(status.to_s),
          "(#{(clock_time - began_at).round(3)}s)"
        ].join(" ")

        response
      end

      private

      def time_string
        Pastel.new.dark.white(Time.now.strftime("%H:%M:%S.%3N"))
      end

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
  end
end
