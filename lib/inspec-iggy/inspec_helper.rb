#
# Author:: Matt Ray (<matt@chef.io>)
#
# Copyright:: 2018, Chef Software, Inc <legal@chef.io>
#

require "inspec"

module Iggy
  class InspecHelper

    # constants for the InSpec resources
    RESOURCES = Inspec::Resource.registry.keys

    # translate Terraform resource name to InSpec
    TERRAFORM_RESOURCES = {
      "aws_instance" => "aws_ec2_instance",
      # 'aws_route' => 'aws_route_table' # needs route_table_id instead of id
    }

    # # there really should be some way to get this directly from InSpec's resources
    def self.resource_properties(resource)
      # remove the common methods, in theory only leaving only unique InSpec properties
      inspec_properties = Inspec::Resource.registry[resource].instance_methods - COMMON_PROPERTIES
      # get InSpec properties by method names
      inspec_properties.collect! { |x| x.to_s }
      Inspec::Log.debug "Iggy::InspecHelper.resource_properties #{resource} properties = #{inspec_properties}"

      inspec_properties
    end

    def self.print_commands(extracted_profiles)
      extracted_profiles.keys.each do |cmd|
        type = extracted_profiles[cmd]["type"]
        url = extracted_profiles[cmd]["url"]
        key_name = extracted_profiles[cmd]["key_name"]
        if type == "aws_instance"
          ip = extracted_profiles[cmd]["public_ip"]
          puts "inspec exec #{url} -t ssh://#{ip} -i #{key_name}"
        else
          puts "inspec exec #{url} -t aws://us-west-2"
        end
      end
    end

    def self.print_controls(file, generated_controls)
      puts "# encoding: utf-8\n#"

      puts "\ntitle '#{File.absolute_path(file)} controls generated by Iggy v#{Iggy::VERSION}'"

      # write all controls
      puts generated_controls.flatten.map(&:to_ruby).join("\n\n")
    end

    # a hack for sure, finds common methods as proxy for InSpec properties
    COMMON_PROPERTIES = Inspec::Resource.registry["aws_subnet"].instance_methods &
      Inspec::Resource.registry["directory"].instance_methods
  end
end
