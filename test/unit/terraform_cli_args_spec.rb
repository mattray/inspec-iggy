# This unit test performs some tests to verify that the command line options for
# inspec-iggy are correct.

# Include our test harness
require_relative '../helper'

# Load the class under test, the CliCommand definition.
require 'inspec-iggy/terraform/cli_command'

# Because InSpec is a Spec-style test suite, we're going to use RSpec
# here, for familiar look and feel. However, this isn't InSpec code.
describe 'inspec terraform CLI options' do

  # This is the CLI Command implementation class.
  # It is a subclass of Thor, which is a CLI framework.
  # This unit test file is mostly about verifying the Thor settings.
  cli_class = InspecPlugins::Iggy::Terraform::CliCommand

  describe 'the number of commands' do
    it 'should have four commands' do
      expect(cli_class.all_commands.count).to eq 4
    end
  end

  # To group tests together, you can nest 'describe' in rspec
  # (that is discouraged in InSpec control code.)
  describe 'the generate command' do

    all_options = [
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

    no_default_options = [
      :name
    ]

    short_options = {
      :name => ['-n'],
      :tfstate => ['-t'],
    }

    boolean_options = [
      :debug,
      :overwrite,
    ]

    # This is a Hash of Structs that tells us details of options for the 'core' subcommand.
    generate_options = cli_class.all_commands['generate'].options

    it 'should have the right option count' do
      expect(generate_options.count).to eq all_options.count
    end

    it 'should have the right options' do
      expect(generate_options.keys.sort).to eq all_options.sort
    end

    it "should have descriptions for all options" do
      all_options.each do |option|
        expect(generate_options[option].description).not_to be nil
      end
    end

    it "should have a default for most options" do
      (all_options - no_default_options).each do |option|
        expect(generate_options[option].default).not_to be nil
      end

      no_default_options.each do |option|
        expect(generate_options[option].required).to be true
      end
    end

    it "should have certain options be typed boolean" do
      boolean_options.each do |option|
        expect(generate_options[option].type).to be :boolean
      end
    end

    it "should have some options be abbreviated" do
      short_options.each do |option, abbrevs|
        expect(generate_options[option].aliases.sort).to eq abbrevs.sort
      end
    end

    # Argument count
    # The 'generate' command does not accept arguments.
    it "should take no arguments" do
      expect(cli_class.instance_method(:generate).arity).to eq(0)
    end

  end


  # To group tests together, you can nest 'describe' in rspec
  # (that is discouraged in InSpec control code.)
  describe 'the extract command' do

    all_options = [
    ]

    extract_options = cli_class.all_commands['extract'].options

    it 'should have the correct option count' do
      expect(extract_options.count).to eq all_options.count
    end

    # Argument count
    # The 'generate' command does not accept arguments.
    it "should take no arguments" do
      expect(cli_class.instance_method(:generate).arity).to eq(0)
    end

  end
end
