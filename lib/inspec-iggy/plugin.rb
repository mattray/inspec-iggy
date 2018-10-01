# encoding: UTF-8

# Plugin Definition file
# The purpose of this file is to declare to InSpec what plugin_types (capabilities)
# are included in this plugin, and provide hooks that will load them as needed.

# It is important that this file load successfully and *quickly*.
# Your plugin's functionality may never be used on this InSpec run; so we keep things
# fast and light by only loading heavy things when they are needed.

require 'inspec/plugin/v2'

# The InspecPlugins namespace is where all plugins should declare themselves.
# The 'Inspec' capitalization is used throughout the InSpec source code; yes, it's
# strange.
module InspecPlugins
  # Pick a reasonable namespace here for your plugin.  A reasonable choice
  # would be the CamelCase version of your plugin gem name.
  module Iggy
    class Plugin < ::Inspec.plugin(2)
      # Internal machine name of the plugin. InSpec will use this in errors, etc.
      plugin_name :'inspec-iggy'

      cli_command :terraform do
        # Calling this hook doesn't mean iggy is being executed - just
        # that we should be ready to do so. So, load the file that defines the
        # functionality.
        # For example, InSpec will activate this hook when `inspec help` is
        # executed, so that this plugin's usage message will be included in the help.
        require 'inspec-iggy/terraform_cli'

        # Having loaded our functionality, return a class that will let the
        # CLI engine tap into it.
        InspecPlugins::Iggy::TerraformCliCommand
      end
    end
  end
end
