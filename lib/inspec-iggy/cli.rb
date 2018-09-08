# encoding: utf-8
#
# Author:: Matt Ray (<matt@chef.io>)
#
# Copyright:: 2018, Chef Software, Inc <legal@chef.io>
#

require 'inspec/plugin/v1'
require 'thor'

require 'inspec-iggy/terraform'
require 'inspec-iggy/cloudformation'
require 'inspec-iggy/profile'

module Terraform
  class CLI < Thor
    namespace 'terraform'

    map %w{-v --version} => 'version'

    desc 'version', 'Display version information', hide: true
    def version
      say("Iggy v#{Iggy::VERSION}")
    end

    option :debug,
           desc: 'Verbose debugging messages',
           type: :boolean,
           default: false

    option :copyright,
           desc: 'Name of the copyright holder',
           default: 'The Authors'

    option :email,
           desc: 'Email address of the author',
           default: 'you@example.com'

    option :license,
           desc: 'License for the profile',
           default: 'Apache-2.0'

    option :maintainer,
           desc: 'Name of the copyright holder',
           default: 'The Authors'

    option :summary,
           desc: 'One line summary for the profile',
           default: 'An InSpec Compliance Profile'

    option :title,
           desc: 'Human-readable name for the profile',
           default: 'InSpec Profile'

    option :version,
           desc: 'Specify the profile version',
           default: '0.1.0'

    option :overwrite,
           desc: 'Overwrites existing profile directory',
           type: :boolean,
           default: false

    option :name,
           aliases: '-n',
           required: true,
           desc: 'Name of profile to be generated'

    option :tfstate,
           aliases: '-t',
           desc: 'Specify path to the input terraform.tfstate',
           default: 'terraform.tfstate'

    desc 'generate [options]', 'Generate InSpec compliance controls from terraform.tfstate'
    def generate
      Inspec::Log.level = :debug if options[:debug]
      generated_controls = Iggy::Terraform.parse_generate(options[:tfstate])
      printable_controls = Iggy::InspecHelper.tf_controls(options[:title], generated_controls)
      Iggy::Profile.render_profile(options, options[:tfstate], printable_controls)
      exit 0
    end

    desc 'extract [options]', 'Extract tagged InSpec profiles from terraform.tfstate'
    def extract
      Inspec::Log.level = :debug if options[:debug]
      extracted_profiles = Iggy::Terraform.parse_extract(options[:tfstate])
      puts Iggy::InspecHelper.print_commands(extracted_profiles)
      exit 0
    end
  end

  Inspec::Plugins::CLI.add_subcommand(CLI, 'terraform', 'terraform SUBCOMMAND ...', 'Extract or generate InSpec from Terraform', {})
end

module CloudFormation
  class CLI < Thor
    namespace 'cloudformation'

    map %w{-v --version} => 'version'

    desc 'version', 'Display version information', hide: true
    def version
      say("Iggy v#{Iggy::VERSION}")
    end

    class_option :debug,
                 desc: 'Verbose debugging messages',
                 type: :boolean,
                 default: false

    class_option :stack,
                 aliases: '-s',
                 required: true,
                 desc: 'Specify stack name or unique stack ID associated with the CloudFormation template'

    class_option :template,
                 aliases: '-t',
                 required: true,
                 desc: 'Specify path to the input CloudFormation template'

    desc 'generate [options]', 'Generate InSpec compliance controls from CloudFormation template'
    def generate
      Inspec::Log.level = :debug if options[:debug]
      # hash of generated controls
      generated_controls = Iggy::CloudFormation.parse_generate(options[:template])
      printable_controls = Iggy::InspecHelper.cfn_controls(options[:title], generated_controls, options[:stack])
      Iggy::Profile.render_profile(options, options[:template], printable_controls)
      exit 0
    end
  end

  Inspec::Plugins::CLI.add_subcommand(CLI, 'cloudformation', 'cloudformation SUBCOMMAND ...', 'Generate InSpec from CloudFormation', {})
end
