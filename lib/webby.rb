require_relative "command"

module Webby
  VERSION = "1.0.3"

  def self.init
    cmd = Webby::Command.new
    cmd.parse
    cmd.run
  end
end
