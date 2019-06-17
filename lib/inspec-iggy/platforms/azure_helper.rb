# helpers for working with InSpec-AWS profiles

require 'yaml'

module InspecPlugins::Iggy::Platforms
  class AzureHelper

    # find the additional parameters
    AZURE_RESOURCE_QUALIFIERS = {
    }.freeze

    # readme content
    def self.readme
      return "\n"
    end

    # inspec.yml boilerplate content from
    # inspec/lib/plugins/inspec-init/templates/profiles/azure/inspec.yml
    def self.inspec_yml
      yml = {}
      yml['inspec_version'] = '>= 2.2.7'
      yml['depends'] = [{
        'name' => 'inspec-azure',
        'url' => 'https://github.com/inspec/inspec-azure/archive/master.tar.gz'
      }]
      yml['supports'] = [{
        'platform' => 'azure'
      }]
      return yml
    end
  end
end
