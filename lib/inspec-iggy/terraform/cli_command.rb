# Terraform CLI command and options

require "inspec/plugin/v2"

require "inspec-iggy/version"
require "inspec-iggy/profile_helper"
require "inspec-iggy/terraform/generate"
require "inspec-iggy/terraform/negative"

module InspecPlugins::Iggy
  module Terraform
    class CliCommand < Inspec.plugin(2, :cli_command)
      subcommand_desc "terraform SUBCOMMAND ...", "Generate an InSpec profile from Terraform"

      class_option :debug,
                   desc: "Verbose debugging messages",
                   type: :boolean,
                   default: false

      class_option :copyright,
                   desc: "Name of the copyright holder",
                   default: "The Authors"

      class_option :email,
                   desc: "Email address of the author",
                   default: "you@example.com"

      class_option :license,
                   desc: "License for the profile",
                   default: "Apache-2.0"

      class_option :maintainer,
                   desc: "Name of the copyright holder",
                   default: "The Authors"

      class_option :summary,
                   desc: "One line summary for the profile",
                   default: "An InSpec Compliance Profile"

      class_option :title,
                   desc: "Human-readable name for the profile",
                   default: "InSpec Profile"

      class_option :version,
                   desc: "Specify the profile version",
                   default: "0.1.0"

      class_option :overwrite,
                   desc: "Overwrites existing profile directory",
                   type: :boolean,
                   default: false

      class_option :name,
                   aliases: "-n",
                   required: true,
                   desc: "Name of profile to be generated"

      class_option :tfstate,
                   aliases: "-t",
                   desc: "Specify path to the input terraform.tfstate",
                   default: "terraform.tfstate"

      class_option :platform,
                   required: true,
                   desc: "The InSpec platform providing the necessary resources (aws, azure, or gcp)"

      class_option :resourcepath,
                   required: true,
                   desc: "Specify path to the InSpec Resource Pack providing the necessary resources"

      desc "generate [options]", "Generate InSpec compliance controls from terraform.tfstate"
      def generate
        Inspec::Log.level = :debug if options[:debug]
        platform = options[:platform]
        resource_path = options[:resourcepath]
        generated_controls = InspecPlugins::Iggy::Terraform::Generate.parse_generate(options[:tfstate], resource_path, platform)
        printable_controls = InspecPlugins::Iggy::InspecHelper.tf_controls(options[:title], generated_controls, platform)
        InspecPlugins::Iggy::ProfileHelper.render_profile(ui, options, options[:tfstate], printable_controls, platform)
        exit 0
      end

      desc "negative [options]", "Generate negative InSpec compliance controls from terraform.tfstate"
      def negative
        Inspec::Log.level = :debug if options[:debug]
        platform = options[:platform]
        resource_path = options[:resourcepath]
        # require validation that if platform or resourcepath are passed, both are available
        if platform || resource_path
          unless platform && resource_path
            error "You must pass both --platform and --resourcepath if using either"
            exit(1)
          end
        end
        negative_controls = InspecPlugins::Iggy::Terraform::Negative.parse_negative(options[:tfstate], resource_path, platform)
        printable_controls = InspecPlugins::Iggy::InspecHelper.tf_controls(options[:title], negative_controls, platform)
        InspecPlugins::Iggy::ProfileHelper.render_profile(ui, options, options[:tfstate], printable_controls, platform)
        exit 0
      end
    end
  end
end
