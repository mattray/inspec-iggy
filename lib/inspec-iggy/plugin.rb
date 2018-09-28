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
    end
  end
end
