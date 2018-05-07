#
# Author:: Matt Ray (<matt@chef.io>)
#
# Copyright:: 2018, Chef Software, Inc <legal@chef.io>
#

require "iggy"

require "json"
require "thor"

module Iggy
  class Terraform < Thor
    # makes it easier to change out later
    TAG_NAME = "iggy_name_"
    TAG_URL = "iggy_url_"

    class_option :tfstate,
      :aliases => "-t",
      :desc    => "Specify path to the input terraform.tfstate",
      :default => "terraform.tfstate"

    class_option :debug,
      :desc    => "Verbose debugging messages",
      :type    => :boolean,
      :default => false

    desc "extract [options]", "Extract tagged InSpec profiles from terraform.tfstate"
    def extract
      Iggy::Log.level = :debug if options[:debug]
      # hash of tagged compliance profiles
      extracted_profiles = parse_extract(options[:tfstate])
      Iggy::Log.debug "Terraform.extract extracted_profiles = #{extracted_profiles}"
      Iggy::Inspec.print_commands(extracted_profiles)
      exit 0
    end

    desc "generate [options]", "Generate InSpec compliance controls from terraform.tfstate"
    def generate
      Iggy::Log.level = :debug if options[:debug]
      # hash of generated controls
      generated_controls = parse_generate(options[:tfstate])
      Iggy::Log.debug "Terraform.generate generated_controls = #{generated_controls}"
      # let's just generate a control file with a set of controls for now
      Iggy::Inspec.print_controls(options[:tfstate], generated_controls)
      exit 0
    end

    private

    # boilerplate tfstate parsing
    def parse_tfstate(file)
      Iggy::Log.debug "Terraform.parse_tfstate file = #{file}"
      begin
        unless File.file?(file)
          STDERR.puts "ERROR: #{file} is an invalid file, please check your path."
          exit(-1)
        end
        tfstate = JSON.parse(File.read(file))
      rescue JSON::ParserError => e
        STDERR.puts e.message
        STDERR.puts "ERROR: Parsing error in #{file}."
        exit(-1)
      end
    end

    # parse through the JSON for the tagged Resources
    def parse_extract(file)
      tfstate = parse_tfstate(file)

      # InSpec profiles extracted
      extracted_profiles = {}

      # iterate over the resources
      tf_resources = tfstate["modules"][0]["resources"]
      tf_resources.keys.each do |tf_res|
        tf_res_id = tf_resources[tf_res]["primary"]["id"]

        # get the attributes, see if any of them have a tagged profile attached
        tf_resources[tf_res]['primary']['attributes'].keys.each do |attr|
          next unless attr.start_with?("tags."+TAG_NAME)
          Iggy::Log.debug "Terraform.parse_extract tf_res = #{tf_res} attr = #{attr} MATCHED TAG"
          # get the URL and the name of the profiles
          name = attr.split(TAG_NAME)[1]
          url = tf_resources[tf_res]['primary']['attributes']["tags.#{TAG_URL}#{name}"]
          if tf_res.start_with?("aws_vpc") # should this be VPC or subnet?
            # if it's a VPC, store it as the VPC id + name
            key = tf_res_id + ":" + name
            Iggy::Log.debug "Terraform.parse_extract aws_vpc tagged with InSpec #{key}"
            extracted_profiles[key] = {
              "type" => "aws_vpc",
              "az" => "us-west-2",
              "url" => url
            }
          elsif tf_res.start_with?("aws_instance")
            # if it's a node, get information about the IP and SSH/WinRM
            key = tf_res_id + ":" + name
            Iggy::Log.debug "Terraform.parse_extract aws_instance tagged with InSpec #{key}"
            extracted_profiles[key] = {
              "type" => "aws_instance",
              "public_ip" => "192.168.0.1",
              "url" => url
            }
          else
            # should generic AWS just be the default except for instances?
            STDERR.puts "ERROR: #{file} #{tf_res_id} has an InSpec-tagged resource but #{tf_res} is currently unsupported."
            exit(-1)
          end
        end
      end
      extracted_profiles
    end

    # parse through the JSON and generate InSpec controls
    def parse_generate(file)
      tfstate = parse_tfstate(file)
      basename = File.basename(file)
      absolutename = File.absolute_path(file)

      # InSpec controls generated
      generated_controls = {}

      # iterate over the resources
      tf_resources = tfstate["modules"][0]["resources"]
      tf_resources.keys.each do |tf_res|
        tf_res_type = tf_resources[tf_res]["type"]

        # does this match an InSpec resource?
        if Inspec::RESOURCES.include?(tf_res_type)
          Iggy::Log.debug "Terraform.parse_generate tf_res_type = #{tf_res_type} MATCH"
          tf_res_id = tf_resources[tf_res]["primary"]["id"]
          # insert new control based off the resource's ID
          generated_controls[tf_res_id] = {}
          generated_controls[tf_res_id]["name"] = "#{tf_res_type}::#{tf_res_id}"
          generated_controls[tf_res_id]["title"] = "Iggy #{basename} #{tf_res_type}::#{tf_res_id}"
          generated_controls[tf_res_id]["desc"] = "#{tf_res_type}::#{tf_res_id} from the source file #{absolutename}\nGenerated by Iggy v#{Iggy::VERSION}"
          generated_controls[tf_res_id]["impact"] = "1.0"
          generated_controls[tf_res_id]["resource"] = tf_res_type
          generated_controls[tf_res_id]["parameter"] = tf_res_id
          generated_controls[tf_res_id]["tests"] = []
          generated_controls[tf_res_id]["tests"][0] = "it { should exist }"

          # if there's a match, see if there are matching InSpec properties
          inspec_properties = Iggy::Inspec.resource_properties(tf_res_type)
          tf_resources[tf_res]["primary"]["attributes"].keys.each do |attr|
            if inspec_properties.member?(attr)
              Iggy::Log.debug "Terraform.parse_generate #{tf_res_type} inspec_property = #{attr} MATCH"
              value = tf_resources[tf_res]["primary"]["attributes"][attr]
              generated_controls[tf_res_id]["tests"].push("its('#{attr}') { should cmp '#{value}' }")
            else
              Iggy::Log.debug "Terraform.parse_generate #{tf_res_type} inspec_property = #{attr} SKIP"
            end
          end
        else
          Iggy::Log.debug "Terraform.parse_generate tf_res_type = #{tf_res_type} SKIP"
        end
      end
      generated_controls
    end

  end
end
