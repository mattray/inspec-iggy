# This unit test performs some tests to verify that the command line options for
# inspec-iggy are correct.

# Include our test harness
require 'helper'

# Load the class under test, the CliCommand definition.
require 'inspec-iggy/terraform/cli_command'

# In general, plugin authors can choose many different test harnesses, such as RSpec or Minitest/Spec.
# However, Iggy loads all of InSpec, which causes interference with both of those, so here we use
# minitest-assertion style.
module IggyUnitTests
  module TfLets
    def cli_class
      InspecPlugins::Iggy::Terraform::CliCommand
    end

    def commands
      [
        'extract',
        'generate',
        'help',
        'version',
      ]
    end
  end

  class TerraformCli

    # This is the CLI Command implementation class.
    # It is a subclass of Thor, which is a CLI framework.
    # This unit test file is mostly about verifying the Thor settings.


    class CommandSet < Minitest::Test
      include TfLets

      def test_it_should_have_the_right_number_of_commands
        assert_equal(commands.count, cli_class.all_commands.count)
      end

      def test_it_should_have_the_right_commands
        commands.each do |command|
          assert_includes(cli_class.all_commands.keys, command)
        end
      end
    end

    class GenerateCommand < Minitest::Test
      include TfLets

      def all_options
        [
          :copyright,
          :debug,
          :email,
          :license,
          :maintainer,
          :name,
          :overwrite,
          :summary,
          :tfstate,
          :title,
          :version,
        ]
      end

      def no_default_options
        [
          :name
        ]
      end

      def short_options
        {
          :name => ['-n'],
          :tfstate => ['-t'],
        }
      end

      def boolean_options
        [
          :debug,
          :overwrite,
        ]
      end

      # This is a Hash of Structs that tells us details of options for the 'core' subcommand.
      def generate_options
        cli_class.all_commands['generate'].options
      end

      def test_it_should_have_the_right_option_count
        assert_equal(all_options.count, generate_options.count)
      end

      def test_it_should_have_the_right_options
        assert_equal(all_options.sort, generate_options.keys.sort)
      end

      def test_it_should_have_descriptions_for_all_options
        all_options.each do |option|
          refute_nil(generate_options[option].description)
        end
      end

      def test_it_should_have_a_default_for_most_options
        (all_options - no_default_options).each do |option|
          refute_nil(generate_options[option].default)
        end

        no_default_options.each do |option|
          assert(generate_options[option].required)
        end
      end

      def test_it_should_have_certain_options_be_typed_boolean
        boolean_options.each do |option|
          assert_equal(:boolean, generate_options[option].type)
        end
      end

      def test_it_should_have_some_options_be_abbreviated
        short_options.each do |option, abbrevs|
          assert_equal(abbrevs.sort, generate_options[option].aliases.sort)
        end
      end

      # Argument count
      # The 'generate' command does not accept arguments.
      def test_it_should_take_no_arguments
        assert_equal(0, cli_class.instance_method(:generate).arity)
      end
    end
  end

  class ExtractCommand < Minitest::Test
    include TfLets

    def all_options
      []
    end

    def extract_options
      cli_class.all_commands['extract'].options
    end

    def test_it_should_have_the_correct_option_count
      assert_equal(all_options.count, extract_options.count)
    end

    # Argument count
    # The 'generate' command does not accept arguments.
    def test_it_should_take_no_arguments
      assert_equal(0, cli_class.instance_method(:generate).arity)
    end
  end
end
