require "tty-option"
require_relative "server"

module Webby
  class Command
    include TTY::Option

    usage do
      program "webby"
      no_command

      description "Static file hosting"
    end

    flag :help do
      short "-h"
      long "--help"
      desc "Print this page"
    end

    argument :root do
      desc "The directory to run the webserver in"
      optional

      default Dir.pwd
      convert :path
    end

    option :port do
      desc "Define the port used for the webserver"
      short "-p"
      long "--port port"

      default 3000
      convert :integer
    end

    flag :version do
      short "-v"
      long "--version"
      desc "Print the version"
    end

    def run
      if params[:help]
        print help
        exit
      end

      if params.errors.any?
        puts params.errors.summary
        exit 1
      end

      if params[:version]
        puts Webby::VERSION
        exit
      end

      if !params[:port]
        puts "A given port must be an integer"
        exit 1
      end

      unless params[:root].exist?
        puts "Root directory does not exist"
        exit 1
      end

      unless params[:root].directory?
        puts "Root is not a directory"
        exit 1
      end

      Webby::Server.new(params[:port], params[:root]).start
    end
  end
end
