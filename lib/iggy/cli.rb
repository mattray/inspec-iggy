#
# Author:: Matt Ray (<matt@chef.io>)
#
# Copyright:: 2018, Chef Software, Inc <legal@chef.io>
#

require "iggy"
require "thor"

class Iggy::CLI < Thor
  def self.exit_on_failure?
    true
  end

  desc "terraform [options]", "Convert a Terraform file into an InSpec compliance profile"

  class_option :debug,
    :desc    => "Verbose debugging messages",
    :type    => :boolean,
    :default => false

  option :file,
    :aliases => "-f",
    :desc    => "Specify path to the input file",
    :default => "terraform.tfstat"

  option :profile,
    :aliases => "-p",
    :desc    => "Name of profile to generate",
    :default => "iggy"

  def terraform
    Iggy::Log.level = :debug if options[:debug]
    Iggy::Log.debug "file = #{options[:file]}"
    Iggy::Log.debug "profile = #{options[:profile]}"

    puts "LETS GET IT STARTED"
    # read in the terraform.tfstate
    # look for tags
    # map aws resources to inspec resources
    # generate profile

    exit 0
  end

  map %w{-v --version} => "version"

  desc "version", "Display version information", hide: true
  def version
    say("Iggy v#{Iggy::VERSION}")
  end
end
