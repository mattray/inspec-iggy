#
# Author:: Matt Ray (<matt@chef.io>)
#
# Copyright:: 2018, Chef Software, Inc <legal@chef.io>
#

require 'iggy'
require 'thor'

class Iggy::CLI < Thor
  def self.exit_on_failure?
    true
  end

  desc 'terraform [options]', 'convert a Terraform file into an INSPEC compliance profile'

  class_option :debug,
    :desc    => 'Verbose debugging messages',
    :type    => :boolean,
    :default => false

  option :file,
    :aliases => '-f',
    :desc    => 'Specify path to the input file',
    :default => 'terraform.tfstat'

  option :profile,
    :aliases => '-p',
    :desc    => 'Name of profile to generate',
    :default => 'iggy'

  def terraform()
    puts "LETS GET IT STARTED"
    puts options[:file]
    puts options[:profile]
  end

  map %w(-v --version) => 'version'

  desc 'version', 'Display version information', hide: true
  def version()
    say("Iggy v#{Iggy::VERSION}")
  end

  # def initialize(_argv = [])
  #   super()
  #   ARGV << '-h' if ARGV.empty?
  #   begin
  #     parse_options
  #   rescue OptionParser::InvalidOption => e
  #     STDERR.puts e.message
  #     puts opt_parser.to_s
  #     exit(-1)
  #   end
  #   Config.merge!(@config)
  #   Iggy::Log.level = :debug if Iggy::Config[:debug]
  # end

  # def run()
  #   Iggy::Log.debug('inputfile: #{Iggy::Config[:inputfile]}')
  #   Iggy::Log.debug('profile: #{Iggy::Config[:profile]}')

  #   # read in the terraform.tfstate
  #   # look for tags
  #   # map aws resources to inspec resources
  #   # generate profile

  #   exit 0
end
