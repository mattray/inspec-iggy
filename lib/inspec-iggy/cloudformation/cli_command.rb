# CloudFormation CLI command and options

require 'inspec/plugin/v2'

require 'inspec-iggy/version'
require 'inspec-iggy/profile_helper'
require 'inspec-iggy/cloudformation/generate'

module InspecPlugins::Iggy
  module CloudFormation
    class CliCommand < Inspec.plugin(2, :cli_command)
      subcommand_desc 'cloudformation SUBCOMMAND ...', 'Generate an InSpec profile from CloudFormation'

      # Thor.map(Hash) allows you to make aliases for commands.
      map('-v' => 'version')         # Treat `inspec terraform -v`` as `inspec terraform version`
      map('--version' => 'version')  # Treat `inspec terraform -version`` as `inspec terraform version`

      desc 'version', 'Display version information', hide: true
      def version
        say("Iggy v#{InspecPlugins::Iggy::VERSION}")
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

      option :stack,
             aliases: '-s',
             required: true,
             desc: 'Specify stack name or unique stack ID associated with the CloudFormation template'

      option :template,
             aliases: '-t',
             required: true,
             desc: 'Specify path to the input CloudFormation template'

      desc 'generate [options]', 'Generate InSpec compliance controls from CloudFormation template'
      def generate
        Inspec::Log.level = :debug if options[:debug]
        # hash of generated controls
        generated_controls = InspecPlugins::Iggy::CloudFormation::Generate.parse_generate(options[:template])
        printable_controls = InspecPlugins::Iggy::InspecHelper.cfn_controls(options[:title], generated_controls, options[:stack])
        InspecPlugins::Iggy::ProfileHelper.render_profile(ui, options, options[:template], printable_controls)
        exit 0
      end
    end
  end
end
