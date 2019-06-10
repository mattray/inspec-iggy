# helpers for working with InSpec-AWS profiles

require 'yaml'

module InspecPlugins::Iggy::Platforms
  class AwsHelper

    # Terraform boilerplate controls/controls.rb content
    def self.tf_controls
      return "\n\naws_vpc_id = attribute('aws_vpc_id', default: '', description: 'Optional AWS VPC identifier.')\n\n"
    end

    # readme content
    def self.readme
      return "\n\nThis profile supports an optional `aws_vpc_id` AWS VPC identifier to be set within the `attributes.yml`.\n\n"
    end

    # inspec.yml boilerplate content from
    # inspec/lib/plugins/inspec-init/templates/profiles/aws/inspec.yml
    def self.inspec_yml
      yml = {}
      yml['inspec_version'] = '~> 4'
      yml['attributes'] = [{
        'name' => 'aws_vpc_id',
        'required' => false,
        'description' => 'Optional Custom AWS VPC Id',
        'default' => '',
        'type' => 'string'
      }]
      yml['depends'] = [{
        'name' => 'inspec-aws',
        'url' => 'https://github.com/inspec/inspec-aws/archive/master.tar.gz'
      }]
      yml['supports'] = [{
        'platform' => 'aws'
      }]
      return yml
    end

    # attributes.yml boilerplate content from
    # inspec/lib/plugins/inspec-init/templates/profiles/aws/attributes.yml
    def self.attributes_yml(cli_ui, name)
      render_file = "#{name}/attributes.yml"
      cli_ui.li "Create file #{cli_ui.mark_text(render_file)}"
      f = File.new(render_file, 'w')
      f.puts("# Below is to be uncommented and set with your AWS Custom VPC ID:")
      f.puts("# aws_vpc_id: 'vpc-xxxxxxx'")
      f.close
    end

  end
end
