# This unit test performs some tests to verify that
# the inspec-iggy plugin is configured correctly.

# Include our test harness
require_relative '../helper'

# Load the class under test, the Plugin definition.
require 'inspec-iggy/plugin'

# Because InSpec is a Spec-style test suite, we're going to use MiniTest::Spec
# here, for familiar look and feel. However, this isn't InSpec (or RSpec) code.

describe InspecPlugins::Iggy::Plugin do

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
  it "should be registered" do
    expect(registry.known_plugin?(plugin_name)).to be true
  end

  # The plugin system formerly had an undocumented v1 API;
  # this should be a real v2 plugin.
  it "should be an api-v2 plugin" do
    expect(status.api_generation).to eq 2
  end

  # Plugins can support several different activator hooks, each of which has a type.
  # Since this is a CliCommand plugin, we'd expect to see that among our types.
  it "should include a cli_command activator hook" do
    expect(status.plugin_types).to include(:cli_command)
  end
end
