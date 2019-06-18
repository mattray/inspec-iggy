# constants and helpers for working with InSpec

require 'inspec'

require 'inspec-iggy/platforms/aws_helper'
require 'inspec-iggy/platforms/azure_helper'
require 'inspec-iggy/platforms/gcp_helper'

module InspecPlugins
  module Iggy
    class InspecHelper
      @inspec_resources = Inspec::Resource.registry.keys

      # list of resources available from InSpec
      def self.available_resources
        @inspec_resources
      end

      # translate Terraform resource name to InSpec
      TRANSLATED_RESOURCES = {
        'aws_instance' => 'aws_ec2_instance',
        'aws_v_p_c' => 'aws_vpc', # CFN
        'azurerm_resource_group' => 'azure_resource_group',
        'azurerm_virtual_machine' => 'azure_virtual_machine'
        # "azure_virtual_machine_data_disk",
        # 'aws_route' => 'aws_route_table' # needs route_table_id instead of id
      }.freeze

      def self.available_resource_qualifiers(platform)
        case platform
        when 'aws'
          return InspecPlugins::Iggy::Platforms::AwsHelper::AWS_RESOURCE_QUALIFIERS
        when 'azure'
          return InspecPlugins::Iggy::Platforms::AzureHelper::AZURE_RESOURCE_QUALIFIERS
        when 'gcp'
          return InspecPlugins::Iggy::Platforms::GcpHelper::GCP_RESOURCE_QUALIFIERS
        end
      end

      def self.available_resource_iterators(platform)
        case platform
        when 'aws'
          return InspecPlugins::Iggy::Platforms::AwsHelper::AWS_RESOURCE_ITERATORS
        when 'azure'
          return InspecPlugins::Iggy::Platforms::AzureHelper::AZURE_RESOURCE_ITERATORS
        when 'gcp'
          return InspecPlugins::Iggy::Platforms::GcpHelper::GCP_RESOURCE_ITERATORS
        end
      end

      # manually maintained common methods we don't want to test InSpec properties
      REMOVED_COMMON_PROPERTIES = [
        :!,
        :!=,
        :!~,
        :<=>,
        :==,
        :===,
        :=~,
        :__binding__,
        :__id__,
        :__send__,
        :check_supports,
        :class,
        :clone,
        :dclone,
        :define_singleton_method,
        :display,
        :dup,
        :enum_for,
        :eql?,
        :equal?,
        :extend,
        :fail_resource,
        :freeze,
        :frozen?,
        :hash,
        :inspec,
        :inspect,
        :instance_eval,
        :instance_exec,
        :instance_of?,
        :instance_variable_defined?,
        :instance_variable_get,
        :instance_variable_set,
        :instance_variables,
        :is_a?,
        :itself,
        :kind_of?,
        :method,
        :methods,
        :nil?,
        :object_id,
        :pretty_inspect,
        :pretty_print,
        :pretty_print_cycle,
        :pretty_print_inspect,
        :pretty_print_instance_variables,
        :private_methods,
        :protected_methods,
        :pry,
        :public_method,
        :public_methods,
        :public_send,
        :remove_instance_variable,
        :resource_exception_message,
        :resource_failed?,
        :resource_skipped?,
        :respond_to?,
        :send,
        :should,
        :should_not,
        :singleton_class,
        :singleton_method,
        :singleton_methods,
        :skip_resource,
        :taint,
        :tainted?,
        :tap,
        :then,
        :to_enum,
        :to_json,
        :to_s,
        :to_yaml,
        :trust,
        :untaint,
        :untrust,
        :untrusted?,
        :yield_self,
      ]

      # properties are often dynamically generated, making it hard to determine
      # their existence without instantiating them. Because of this, we will
      # maintain a manual list for now
      ADDITIONAL_COMMON_PROPERTIES = [
        # :backend_service, # documented but undefined
        # :id, #disabled for GCP
        # :ip_version, # documented but undefined
        # :network, # documented but undefined
        # :subnetwork, # documented but undefined
        :allowed,
        :creation_timestamp,
        :description,
        :description,
        :direction,
        :ip_address,
        :ip_protocol,
        :kind,
        :load_balancing_scheme,
        :name,
        :port_range,
        :ports,
        :priority,
        :region,
        :self_link,
        :source_ranges,
        :target,
        :target_tags,
      ]

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
        Dir.glob("#{libpath}/*.rb").each do |x|
          begin
            require(x)
          rescue Exception =>e # AWS is blowing up for some reason
            puts e
          end
        end
        @inspec_resources = Inspec::Resource.registry.keys
      end

      # there really should be some way to get this directly from InSpec's resources
      def self.resource_properties(resource, platform)
        # remove the common methods, in theory only leaving only unique InSpec properties
        inspec_properties = Inspec::Resource.registry[resource].instance_methods + ADDITIONAL_COMMON_PROPERTIES
        inspec_properties -= REMOVED_COMMON_PROPERTIES
        case platform
        when 'aws'
          inspec_properties -= InspecPlugins::Iggy::Platforms::AwsHelper::AWS_REMOVED_PROPERTIES[resource] unless InspecPlugins::Iggy::Platforms::AwsHelper::AWS_REMOVED_PROPERTIES[resource].nil?
        when 'azure'
          inspec_properties -= InspecPlugins::Iggy::Platforms::AzureHelper::AZURE_REMOVED_PROPERTIES[resource] unless InspecPlugins::Iggy::Platforms::AzureHelper::AZURE_REMOVED_PROPERTIES[resource].nil?
        when 'gcp'
          inspec_properties -= InspecPlugins::Iggy::Platforms::GcpHelper::GCP_REMOVED_PROPERTIES[resource] unless InspecPlugins::Iggy::Platforms::GcpHelper::GCP_REMOVED_PROPERTIES[resource].nil?
        end
        # get InSpec properties by method names
        inspec_properties.collect!(&:to_s)
        Inspec::Log.debug "InspecHelper.resource_properties #{resource} properties = #{inspec_properties}"

        inspec_properties
      end

      def self.tf_controls(title, generated_controls, platform)
        content = "title \"#{title}: generated by Iggy v#{Iggy::VERSION}\"\n"

        content += InspecPlugins::Iggy::Platforms::AwsHelper.tf_controls if platform.eql?('aws')

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

    end

  end
end
