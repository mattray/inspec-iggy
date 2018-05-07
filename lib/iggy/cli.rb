#
# Author:: Matt Ray (<matt@chef.io>)
#
# Copyright:: 2018, Chef Software, Inc <legal@chef.io>
#

require "iggy/cloudformation"
require "iggy/terraform"

require "thor"

class Iggy::CLI < Thor
  def self.exit_on_failure?
    true
  end

  map %w{-v --version} => "version"

  desc "version", "Display version information", hide: true
  def version
    say("Iggy v#{Iggy::VERSION}")
  end

  # bring this back once it works
  # desc "cfn SUBCOMMAND [options]", "Generate InSpec from CloudFormation"
  # subcommand "cfn", Iggy::CloudFormation

  desc "terraform SUBCOMMAND [options]", "Extract or generate InSpec from Terraform"
  subcommand "terraform", Iggy::Terraform
end
