# helpers for working with InSpec-AWS profiles

require 'yaml'

module InspecPlugins::Iggy::Platforms
  class AwsHelper
    # find the additional parameters
    AWS_RESOURCE_QUALIFIERS = {
    }.freeze

    # the iterators for the various resource types
    AWS_RESOURCE_ITERATORS = {
    }.freeze

    AWS_REMOVED_PROPERTIES = {
    }.freeze

    # Terraform boilerplate controls/controls.rb content
    def self.tf_controls
      "\n\naws_vpc_id = attribute('aws_vpc_id', value: '', description: 'Optional AWS VPC identifier.')\n\n"
    end

    # readme content
    def self.readme
    end

    # inspec.yml boilerplate content from
    # inspec/lib/plugins/inspec-init/templates/profiles/aws/inspec.yml
    def self.inspec_yml
      yml = {}
      yml['inspec_version'] = '~> 4'
      yml['depends'] = [{
        'name' => 'inspec-aws',
        'url' => 'https://github.com/inspec/inspec-aws/archive/master.tar.gz'
      }]
      yml['supports'] = [{
        'platform' => 'aws'
      }]
      yml
    end
  end
end
