# encoding: utf-8
#
# Author:: Matt Ray (<matt@chef.io>)
#
# Copyright:: 2018, Chef Software, Inc <legal@chef.io>
#

require "inspec/plugins"
require "thor"

require "inspec-iggy/terraform"
require "inspec-iggy/cloudformation"

module Terraform
  class CLI < Thor
    namespace "terraform"

    map %w{-v --version} => "version"

    desc "version", "Display version information", hide: true
    def version
      say("Iggy v#{Iggy::VERSION}")
    end

    class_option :tfstate,
      :aliases => "-t",
      :desc    => "Specify path to the input terraform.tfstate",
      :default => "terraform.tfstate"

    class_option :debug,
      :desc    => "Verbose debugging messages",
      :type    => :boolean,
      :default => false

    desc "generate [options]", "Generate InSpec compliance controls from terraform.tfstate"
    def generate
      Inspec::Log.level = :debug if options[:debug]
      generated_controls = Iggy::Terraform.parse_generate(options[:tfstate])
      # let's just generate a control file with a set of controls for now
      Iggy::InspecHelper.print_controls(options[:tfstate], generated_controls)
      exit 0
    end

    desc "extract [options]", "Extract tagged InSpec profiles from terraform.tfstate"
    def extract
      Inspec::Log.level = :debug if options[:debug]
      extracted_profiles = Iggy::Terraform.parse_extract(options[:tfstate])
      Iggy::InspecHelper.print_commands(extracted_profiles)
      exit 0
    end
  end

  Inspec::Plugins::CLI.add_subcommand(CLI, "terraform", "terraform SUBCOMMAND ...", "Extract or generate InSpec from Terraform", {})
end

module CloudFormation
  class CLI < Thor
    namespace "cloudformation"

    map %w{-v --version} => "version"

    desc "version", "Display version information", hide: true
    def version
      say("Iggy v#{Iggy::VERSION}")
    end

    class_option :template,
      :aliases => "-t",
      :desc    => "Specify path to the input CloudFormation template"

    class_option :debug,
      :desc    => "Verbose debugging messages",
      :type    => :boolean,
      :default => false

    desc "generate [options]", "Generate InSpec compliance controls from CloudFormation template"
    def generate
      Inspec::Log.level = :debug if options[:debug]
      # hash of generated controls
      generated_controls = Iggy::CloudFormation.parse_generate(options[:template])
      # let's just generate a control file with a set of controls for now
      Iggy::InspecHelper.print_controls(options[:template], generated_controls)
      exit 0
    end
  end

  Inspec::Plugins::CLI.add_subcommand(CLI, "cloudformation", "cloudformation SUBCOMMAND ...", "Generate InSpec from CloudFormation", {})
end
