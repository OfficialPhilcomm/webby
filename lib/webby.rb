require_relative "command"

module Webby
  VERSION = "1.0.2"

  def self.init
    cmd = Webby::Command.new
    cmd.parse
    cmd.run
  end
end
