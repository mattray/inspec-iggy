# constants and helpers for working with InSpec

require 'inspec'

module InspecPlugins
  module Iggy
    class InspecHelper
      # translate Terraform resource name to InSpec
      TRANSLATED_RESOURCES = {
        'aws_instance' => 'aws_ec2_instance',
        'aws_v_p_c' => 'aws_vpc', # CFN
        'azurerm_resource_group' => 'azure_resource_group',
        'azurerm_virtual_machine' => 'azure_virtual_machine'
        # "azure_virtual_machine_data_disk",
        # 'aws_route' => 'aws_route_table' # needs route_table_id instead of id
      }.freeze

      @inspec_resources = Inspec::Resource.registry.keys

      # list of resources available from InSpec
      def self.available_resources
        @inspec_resources
      end

      # load the resource pack into InSpec::Resource.registry
      def self.load_resource_pack(resource_path)
        # find the libraries path in the resource pack
        if resource_path.end_with?('libraries')
          libpath = resource_path
        else
          libpath = resource_path+'/libraries'
        end
        $LOAD_PATH.push(libpath)
        # find all the classes in the libpath and require them
        # this adds them to the Inspec::Resource.registry
        Dir.glob("#{libpath}/*.rb").each { |x| require(x) }
        @inspec_resources = Inspec::Resource.registry.keys
      end

      # there really should be some way to get this directly from InSpec's resources
      def self.resource_properties(resource)
        # remove the common methods, in theory only leaving only unique InSpec properties
        inspec_properties = Inspec::Resource.registry[resource].instance_methods - COMMON_PROPERTIES
        # get InSpec properties by method names
        inspec_properties.collect!(&:to_s)
        Inspec::Log.debug "InspecHelper.resource_properties #{resource} properties = #{inspec_properties}"

        inspec_properties
      end

      def self.tf_controls(title, generated_controls)
        content = "# encoding: utf-8\n#\n\n"

        content += "title \"#{title}: generated by Iggy v#{Iggy::VERSION}\"\n"

        # write all controls
        content + generated_controls.flatten.map(&:to_ruby).join("\n\n")
      end

      def self.cfn_controls(title, generated_controls, stack)
        content = "# encoding: utf-8\n#\n\n"

        content += "begin\n"
        content += "  awsclient = Aws::CloudFormation::Client.new()\n"
        content += "  cfn = awsclient.list_stack_resources({ stack_name: \"#{stack}\" }).to_hash\n"
        content += "  resources = {}\n"
        content += "  cfn[:stack_resource_summaries].each { |r| resources[r[:logical_resource_id]] = r[:physical_resource_id] }\n"
        content += "rescue Exception => e\n"
        content += "  raise(e) unless @conf['profile'].check_mode\n"
        content += "end\n\n"

        content += "title \"#{title}: generated by Iggy v#{Iggy::VERSION}\"\n"

        # get the controls, insert lookups for physical_resource_ids
        controls = generated_controls.flatten.map(&:to_ruby).join("\n\n")
        controls.gsub!(/\"resources\[/, 'resources["')
        controls.gsub!(/\]\"/, '"]')
        content + controls
      end

      # a hack for sure, finds common methods as proxy for InSpec properties
      COMMON_PROPERTIES = Inspec::Resource.registry['aws_subnet'].instance_methods &
                          Inspec::Resource.registry['directory'].instance_methods
    end

    # disabled extract functionality
    # def self.print_commands(extracted_profiles)
    #   extracted_profiles.keys.each do |cmd|
    #     type = extracted_profiles[cmd]['type']
    #     url = extracted_profiles[cmd]['url']
    #     key_name = extracted_profiles[cmd]['key_name']
    #     if type == 'aws_instance'
    #       ip = extracted_profiles[cmd]['public_ip']
    #       puts "inspec exec #{url} -t ssh://#{ip} -i #{key_name}"
    #     else
    #       puts "inspec exec #{url} -t aws://us-west-2"
    #     end
    #   end
    # end
  end
end
