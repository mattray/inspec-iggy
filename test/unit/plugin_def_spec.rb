# This unit test performs some tests to verify that
# the inspec-iggy plugin is configured correctly.

# Include our test harness
require 'helper'

# Load the class under test, the Plugin definition.
require 'inspec-iggy/plugin'

# In general, plugin authors can choose many different test harnesses, such as RSpec or Minitest/Spec.
# However, Iggy loads all of InSpec, which causes interference with both of those, so here we use
# minitest-assertion style.
module IggyUnitTests
  class Plugin < Minitest::Test

    # When writing tests, you can use `let` to create variables that you
    # can reference easily.

    # Internally, plugins are always known by a Symbol name. Convert here.
    let(:plugin_name) { :'inspec-iggy' }

    # The Registry knows about all plugins that ship with InSpec by
    # default, as well as any that are installed by the user. When a
    # plugin definition is loaded, it will also self-register.
    let(:registry) { Inspec::Plugin::V2::Registry.instance }

    # The plugin status record tells us what the Registry knows.
    # Note that you can use previously-defined 'let's.
    let(:status) { registry[plugin_name] }

    # OK, actual tests!

    # Does the Registry know about us at all?
    def test_it_should_be_registered
      assert(registry.known_plugin?(plugin_name))
    end

    # The plugin system formerly had an undocumented v1 API;
    # this should be a real v2 plugin.
    def test_it_should_be_an_api_v2_plugin
      assert_equal(2, status.api_generation)
    end

    # Plugins can support several different activator hooks, each of which has a type.
    # Since this is a CliCommand plugin, we'd expect to see that among our types.
    def test_it_should_include_a_cli_command_activator_hook
      assert_includes(status.plugin_types, :cli_command)
    end
  end
end
