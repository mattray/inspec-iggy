# This unit test performs some tests to verify that the command line options for
# inspec-iggy are correct.

require 'minitest/autorun'

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
      %w{
        generate
        help
        negative
      }
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
          :log_level,
          :log_location,
          :maintainer,
          :name,
          :overwrite,
          :platform,
          :resourcepath,
          :summary,
          :tfstate,
          :title,
          :version
        ]
      end

      def no_default_options
        [
          :log_level,
          :log_location,
          :name,
          :platform,
          :resourcepath
        ]
      end

      def not_required_options
        [
          :log_level,
          :log_location,
          :platform,
          :resourcepath # AWS is out-of-the-box?
        ]
      end

      def short_options
        {
          name: ['-n'],
          tfstate: ['-t']
        }
      end

      def boolean_options
        [
          :debug,
          :overwrite
        ]
      end

      # This is a Hash of Structs that tells us details of options for the 'core' subcommand.
      def cli_options
        cli_class.class_options
      end

      def test_generate_should_have_the_right_option_count
        assert_equal(all_options.count, cli_options.count)
      end

      def test_generate_should_have_the_right_options
        assert_equal(all_options.sort, cli_options.keys.sort)
      end

      def test_generate_should_have_descriptions_for_all_options
        all_options.each do |option|
          refute_nil(cli_options[option].description)
        end
      end

      def test_generate_should_have_a_default_for_most_options
        (all_options - no_default_options).each do |option|
          refute_nil(cli_options[option].default)
        end

        (no_default_options - not_required_options).each do |option|
          assert(cli_options[option].required)
        end
      end

      def test_generate_should_have_certain_options_be_typed_boolean
        boolean_options.each do |option|
          assert_equal(:boolean, cli_options[option].type)
        end
      end

      def test_generate_should_have_some_options_be_abbreviated
        short_options.each do |option, abbrevs|
          assert_equal(abbrevs.sort, cli_options[option].aliases.sort)
        end
      end

      # Argument count
      # The 'generate' command does not accept arguments.
      def test_generate_should_take_no_arguments
        assert_equal(0, cli_class.instance_method(:generate).arity)
      end

      # 'inspec terraform negative' currently has all the same options as 'generate'
      def test_negative_should_have_the_right_option_count
        assert_equal(all_options.count, cli_options.count)
      end

      def test_negative_should_have_the_right_options
        assert_equal(all_options.sort, cli_options.keys.sort)
      end

      def test_negative_should_have_descriptions_for_all_options
        all_options.each do |option|
          refute_nil(cli_options[option].description)
        end
      end

      def test_negative_should_have_a_default_for_most_options
        (all_options - no_default_options).each do |option|
          refute_nil(cli_options[option].default)
        end

        (no_default_options - not_required_options).each do |option|
          assert(cli_options[option].required)
        end
      end

      def test_negative_should_have_certain_options_be_typed_boolean
        boolean_options.each do |option|
          assert_equal(:boolean, cli_options[option].type)
        end
      end

      def test_negative_should_have_some_options_be_abbreviated
        short_options.each do |option, abbrevs|
          assert_equal(abbrevs.sort, cli_options[option].aliases.sort)
        end
      end

      # Argument count
      # The 'negative' command does not accept arguments.
      def test_negative_should_take_no_arguments
        assert_equal(0, cli_class.instance_method(:negative).arity)
      end
    end
  end
end
