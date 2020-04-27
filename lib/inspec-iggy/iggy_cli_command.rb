# Iggy CLI command and options

require "inspec/plugin/v2"

require "inspec-iggy/version"

module InspecPlugins
  module Iggy
    class CliCommand < Inspec.plugin(2, :cli_command)
      subcommand_desc "iggy", "Use 'inspec cloudformation' or 'inspec terraform'"

      desc "version", "Display version information"
      def version
        say("Iggy v#{InspecPlugins::Iggy::VERSION}")
      end
    end
  end
end
