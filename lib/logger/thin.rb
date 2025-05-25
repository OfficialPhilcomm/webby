module Webby
  module Logger
    class Thin
      def self.level
        @level
      end

      def self.level=(value)
        @level = value
      end

      def self.debug(msg)
        [
          time_string,
          msg
        ]
      end

      def self.info(msg)
        [
          time_string,
          msg
        ]
      end

      def self.warn(msg)
        [
          time_string,
          msg
        ]
      end

      def self.error(msg)
        [
          time_string,
          msg
        ]
      end

      def self.fatal(msg)
        [
          time_string,
          msg
        ]
      end

      def self.unknown(msg)
        [
          time_string,
          msg
        ]
      end

      def self.add(level, msg)
        return if level < @level

        puts case level
        when 0
          self.debug(msg)
        when 1
          self.info(msg)
        when 2
          self.warn(msg)
        when 3
          self.error(msg)
        when 4
          self.fatal(msg)
        when 5
          self.unknown(msg)
        end.join(" ")
      end

      private

      def self.time_string
        Pastel.new.dark.white(Time.now.strftime("%H:%M:%S.%3N"))
      end
    end
  end
end
