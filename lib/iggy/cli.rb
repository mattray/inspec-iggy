# encoding: UTF-8
#
# Author:: Matt Ray (<matt@chef.io>)
#
# Copyright:: 2018, Chef Software, Inc <legal@chef.io>
#

require "mixlib/cli"

module Iggy
  # parse and execute cli options
  class CLI
    include Mixlib::CLI

    banner('Usage: iggy [option] file')

    # option :debug,
    #        long: "--debug",
    #        description: "Verbose debugging messages",
    #        boolean: true

    # option :file,
    #        short: "-f",
    #        long: "--file",
    #        description: "Path to the file to process, defaults to './terraform.tfstate'",
    #        default: 'terraform.tfstate'

    # option :help,
    #        short: "-h",
    #        long: "--help",
    #        description: "Show this message",
    #        on: :tail,
    #        boolean: true,
    #        show_options: true,
    #        exit: 0

    # option :profile,
    #        short: "-p",
    #        long: "--profile",
    #        description: "Name of profile to generate, defaults to 'iggy'",
    #        default: 'iggy'

    option :version,
           short: "-v",
           long: "--version",
           description: "Show iggy version",
           boolean: true,
           proc: ->() { puts "Iggy: #{::Iggy::VERSION}" },
           exit: 0

    def run

      exit 0
    end

  end
end
