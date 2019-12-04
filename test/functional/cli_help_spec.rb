# Include our test harness
require "helper"

module IggyFunctionalTests
  class CliHelp < Minitest::Test
    include CorePluginFunctionalHelper

    def subcommands
      %w{
        cloudformation
        terraform
      }
    end

    def test_iggy_commands_in_toplevel_help
      run_result = run_inspec_process_with_this_plugin("help")
      assert_empty(run_result.stderr)
      assert_equal(0, run_result.exit_status)
      lines = run_result.stdout.split("\n")

      subcommands.each do |subcommand|
        line = lines.detect { |l| l.include? "inspec #{subcommand}" }
        refute_nil(line, "must detect 'inspec #{subcommand}' in top-level usage")
      end
    end

    def test_iggy_commands_should_have_secondary_help
      subcommands.each do |subcommand|
        run_result = run_inspec_process_with_this_plugin("help " + subcommand)
        assert_empty(run_result.stderr, "should have no errors for #{subcommand}")
        assert_equal(0, run_result.exit_status, "should have 0-exit for #{subcommand}")
        lines = run_result.stdout.split("\n")

        # All support generate
        line = lines.detect { |l| l.include? "inspec #{subcommand} generate" }
        refute_nil(line, "must detect 'inspec #{subcommand} generate' in second-level usage")
      end
    end

  end
end
