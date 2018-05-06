# encoding: UTF-8
#
# Author:: Matt Ray (<matt@chef.io>)
#
# Copyright:: 2018, Chef Software, Inc <legal@chef.io>
#

require "mixlib/shellout"

describe "bin/iggy" do
  iggy_binary = File.join(File.dirname(__FILE__), "..", "bin", "iggy")

  it "no options" do
    expected_output = <<-OUTPUT
Commands:
  iggy help [COMMAND]                  # Describe available commands or one specific command
  iggy terraform SUBCOMMAND [options]  # Extract or generate InSpec from Terraform

    OUTPUT
    iggy = Mixlib::ShellOut.new(iggy_binary)
    iggy.run_command
    expect(iggy.stdout).to eq expected_output
  end

  it "help" do
    expected_output = <<-OUTPUT
Commands:
  iggy help [COMMAND]                  # Describe available commands or one specific command
  iggy terraform SUBCOMMAND [options]  # Extract or generate InSpec from Terraform

    OUTPUT
    iggy = Mixlib::ShellOut.new(iggy_binary, "help")
    iggy.run_command
    expect(iggy.stdout).to eq expected_output
  end

  it "help terraform" do
    expected_output = <<-OUTPUT
Commands:
  iggy terraform extract [options]   # Extract tagged InSpec profiles from terraform.tfstate
  iggy terraform generate [options]  # Generate InSpec compliance controls from terraform.tfstate
  iggy terraform help [COMMAND]      # Describe subcommands or one specific subcommand

Options:
  -t, [--tfstate=TFSTATE]      # Specify path to the input terraform.tfstate
                               # Default: terraform.tfstate
      [--debug], [--no-debug]  # Verbose debugging messages

    OUTPUT
    iggy = Mixlib::ShellOut.new(iggy_binary, "help", "terraform")
    iggy.run_command
    expect(iggy.stdout).to eq expected_output
  end

  it "terraform help extract" do
    expected_output = <<-OUTPUT
Usage:
  iggy terraform extract [options]

Options:
  -t, [--tfstate=TFSTATE]      # Specify path to the input terraform.tfstate
                               # Default: terraform.tfstate
      [--debug], [--no-debug]  # Verbose debugging messages

Extract tagged InSpec profiles from terraform.tfstate
    OUTPUT
    iggy = Mixlib::ShellOut.new(iggy_binary, "terraform", "help", "extract")
    iggy.run_command
    expect(iggy.stdout).to eq expected_output
  end

  it "terraform help generate" do
    expected_output = <<-OUTPUT
Usage:
  iggy terraform generate [options]

Options:
  -t, [--tfstate=TFSTATE]      # Specify path to the input terraform.tfstate
                               # Default: terraform.tfstate
      [--debug], [--no-debug]  # Verbose debugging messages

Generate InSpec compliance controls from terraform.tfstate
    OUTPUT
    iggy = Mixlib::ShellOut.new(iggy_binary, "terraform", "help", "generate")
    iggy.run_command
    expect(iggy.stdout).to eq expected_output
  end

  it "version" do
    expected_output = "Iggy v#{Iggy::VERSION}
"
    iggy = Mixlib::ShellOut.new(iggy_binary, "version")
    iggy.run_command
    expect(iggy.stdout).to eq expected_output
  end
end
