# helpers for working with InSpec-GCP profiles

require 'yaml'

module InspecPlugins::Iggy::Platforms
  class GcpHelper

    # readme content
    def self.readme
    end

    # inspec.yml boilerplate content from
    # inspec/lib/plugins/inspec-init/templates/profiles/gcp/inspec.yml
    def self.inspec_yml
      yml = {}
      yml['inspec_version'] = '>= 2.3.5'
      yml['attributes'] = [{
        'name' => 'gcp_project_id',
        'required' => true,
        'description' => 'The GCP project identifier.',
        'type' => 'string'
      }]
      yml['depends'] = [{
        'name' => 'inspec-gcp',
        'url' => 'https://github.com/inspec/inspec-gcp/archive/master.tar.gz',
      }]
      yml['supports'] = [{
        'platform' => 'gcp'
      }]
      return yml
    end
  end
end
