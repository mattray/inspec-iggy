# helpers for working with InSpec-GCP profiles

require 'yaml'

module InspecPlugins::Iggy::Platforms
  class GcpHelper

    # readme content
    def self.readme
      return "\n\nThis profile requires the `gcp_project_id` to be set within the `attributes.yml` to point to your project.\n\n"
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

    # attributes.yml boilerplate content from
    # inspec/lib/plugins/inspec-init/templates/profiles/gcp/attributes.yml
    def self.attributes_yml(cli_ui, name)
      render_file = "#{name}/attributes.yml"
      cli_ui.li "Create file #{cli_ui.mark_text(render_file)}"
      f = File.new(render_file, 'w')
      f.puts("# Below is to be uncommented and set with your GCP project ID:")
      f.puts("# gcp_project_id: 'your-gcp-project'")
      f.close
    end

  end
end
