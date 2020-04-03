# constants and helpers for working with InSpec

require "inspec"

require "inspec-iggy/platforms/aws_helper"
require "inspec-iggy/platforms/azure_helper"
require "inspec-iggy/platforms/gcp_helper"

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
        "aws_instance" => "aws_ec2_instance",
        "aws_v_p_c" => "aws_vpc", # CFN
        "azurerm_resource_group" => "azure_resource_group",
        "azurerm_virtual_machine" => "azure_virtual_machine",
        # "azure_virtual_machine_data_disk",
        # 'aws_route' => 'aws_route_table' # needs route_table_id instead of id
      }.freeze

      def self.available_resource_qualifiers(platform)
        case platform
        when "aws"
          InspecPlugins::Iggy::Platforms::AwsHelper::AWS_RESOURCE_QUALIFIERS
        when "azure"
          InspecPlugins::Iggy::Platforms::AzureHelper::AZURE_RESOURCE_QUALIFIERS
        when "gcp"
          InspecPlugins::Iggy::Platforms::GcpHelper::GCP_RESOURCE_QUALIFIERS
        end
      end

      def self.available_resource_iterators(platform)
        case platform
        when "aws"
          InspecPlugins::Iggy::Platforms::AwsHelper::AWS_RESOURCE_ITERATORS
        when "azure"
          InspecPlugins::Iggy::Platforms::AzureHelper::AZURE_RESOURCE_ITERATORS
        when "gcp"
          InspecPlugins::Iggy::Platforms::GcpHelper::GCP_RESOURCE_ITERATORS
        end
      end

      def self.available_translated_resource_properties(platform, resource)
        case platform
        when "aws"
          InspecPlugins::Iggy::Platforms::AwsHelper::AWS_TRANSLATED_RESOURCE_PROPERTIES[resource]
        when "azure"
          InspecPlugins::Iggy::Platforms::AzureHelper::AZURE_TRANSLATED_RESOURCE_PROPERTIES[resource]
        when "gcp"
          InspecPlugins::Iggy::Platforms::GcpHelper::GCP_TRANSLATED_RESOURCE_PROPERTIES[resource]
        end
      end

      def self.translated_resource_property(platform, resource, property)
        translated_resource = available_translated_resource_properties(platform, resource)
        translated_property = translated_resource[property] if translated_resource
        if translated_property
          Inspec::Log.debug "InspecHelper.translated_resource_property #{platform}:#{resource}:#{property} = #{translated_property} TRANSLATED"
          translated_property
        else
          property
        end
      end

      # properties are often dynamically generated, making it hard to determine
      # their existence without instantiating them. Because of this, we will
      # maintain a manual list for now
      ADDITIONAL_COMMON_PROPERTIES = [
        # :id, #disabled for GCP
        # :tags, # returns emtpy hashes when null
        :addons_config,
        :address,
        :address_type,
        :aggregation_alignment_period,
        :aggregation_cross_series_reducer,
        :aggregation_per_series_aligner,
        :allowed,
        :archive_size_bytes,
        :associations,
        :auto_create_subnetworks,
        :availability_zone,
        :availability_zones,
        :available_cpu_platforms,
        :available_ip_address_count,
        :available_memory_mb,
        :backend_service,
        :backup_pool,
        :base_instance_name,
        :can_ip_forward,
        :canonical_hosted_zone_id,
        :capabilities,
        :change_set_id,
        :check_interval_sec,
        :cidr_block,
        :cloud_watch_logs_log_group_arn,
        :cloud_watch_logs_role_arn,
        :cluster_ipv4_cidr,
        :combiner,
        :common_instance_metadata,
        :condition_threshold_value,
        :conditions,
        :config,
        :cpu_platform,
        :create_time,
        :create_time_date,
        :created_time,
        :creation_record,
        :creation_time,
        :creation_timestamp,
        :creation_timestamp_date,
        :crypto_key_name,
        :crypto_key_url,
        :current_actions,
        :current_master_version,
        :current_node_count,
        :current_node_version,
        :custom_features,
        :dataset,
        :dataset_id,
        :default_exempted_members,
        :default_service_account,
        :default_types,
        :deletion_protection,
        :deletion_time,
        :description,
        :desired_capacity,
        :detailed_status,
        :dhcp_options_id,
        :direction,
        :disable_rollback,
        :disabled,
        :disk_encryption_key,
        :disk_size_gb,
        :disks,
        :display_name,
        :dns_name,
        :dnssec_config,
        :drift_information,
        :ebs_volumes,
        :enable_termination_protection,
        :enabled,
        :enabled_features,
        :endpoint,
        :entry_point,
        :environment_variables,
        :etag,
        :expire_time,
        :external_ports,
        :failover_ratio,
        :family,
        :filename,
        :filter,
        :fingerprint,
        :friendly_name,
        :gateway_address,
        :group_id,
        :group_name,
        :guest_accelerators,
        :guest_os_features,
        :health_check,
        :health_check_type,
        :healthy_threshold,
        :home_region,
        :host,
        :ignored_files,
        :ike_version,
        :image_id,
        :inbound_rules,
        :inbound_rules_count,
        :included_files,
        :included_permissions,
        :initial_cluster_version,
        :initial_node_count,
        :instance_group,
        :instance_group_urls,
        :instance_ids,
        :instance_template,
        :instance_tenancy,
        :internal_ports,
        :ip_address,
        :ip_cidr_range,
        :ip_protocol,
        :ip_version,
        :is_multi_region_trail,
        :key_ring_name,
        :key_ring_url,
        :key_signing_key_algorithm,
        :kind,
        :kms_key_id,
        :kms_key_name,
        :label_fingerprint,
        :label_value_by_key,
        :labels,
        :labels_keys,
        :labels_values,
        :last_attach_timestamp,
        :last_detach_timestamp,
        :last_modified_time,
        :last_updated_time,
        :launch_configuration_name,
        :launch_time,
        :legacy_abac,
        :licenses,
        :lifecycle_state,
        :load_balancer_addresses,
        :load_balancer_arn,
        :load_balancer_name,
        :load_balancing_scheme,
        :local_traffic_selector,
        :location,
        :log_file_validation_enabled,
        :logging_service,
        :machine_type,
        :managed_zone,
        :management,
        :master_auth,
        :max_size,
        :members,
        :metadata,
        :metadata_keys,
        :metadata_value_by_key,
        :metadata_values,
        :min_cpu_platform,
        :min_size,
        :monitoring_service,
        :mutation_record,
        :name,
        :name_servers,
        :named_ports,
        :network,
        :network_interfaces,
        :next_hop_gateway,
        :next_hop_instance,
        :next_hop_ip,
        :next_hop_network,
        :next_hop_vpn_tunnel,
        :next_rotation_time,
        :next_rotation_time_date,
        :node_config,
        :node_ipv4_cidr_size,
        :node_pools,
        :notification_arns,
        :num_bytes,
        :num_long_term_bytes,
        :num_rows,
        :outbound_rules,
        :outbound_rules_count,
        :output_version_format,
        :outputs,
        :owner_id,
        :parameters,
        :parent,
        :parent_id,
        :peer_ip,
        :physical_block_size_bytes,
        :port,
        :port_range,
        :ports,
        :primary_create_time,
        :primary_create_time_date,
        :primary_name,
        :primary_state,
        :priority,
        :private_ip_google_access,
        :private_key,
        :profile,
        :project_id,
        :project_number,
        :propagating_vgws,
        :protocol,
        :proxy_header,
        :purpose,
        :quic_override,
        :quotas,
        :raw_disk,
        :raw_key,
        :region,
        :region_name,
        :remote_traffic_selector,
        :request_path,
        :role_arn,
        :rollback_configuration,
        :root_id,
        :rotation_period,
        :router,
        :routes,
        :routing_config,
        :runtime,
        :s3_bucket_name,
        :scheduling,
        :scheme,
        :security_group_ids,
        :security_groups,
        :self_link,
        :service,
        :service_account_email,
        :service_accounts,
        :services_ipv4_cidr,
        :session_affinity,
        :sha256,
        :shared_secret,
        :shared_secret_hash,
        :size_gb,
        :source_archive_url,
        :source_disk,
        :source_image,
        :source_image_encryption_key,
        :source_image_id,
        :source_ranges,
        :source_snapshot,
        :source_snapshot_encryption_key,
        :source_snapshot_id,
        :source_type,
        :source_upload_url,
        :ssl_certificates,
        :ssl_policy,
        :stack_id,
        :stack_name,
        :stack_status,
        :stack_status_reason,
        :stage,
        :start_restricted,
        :state,
        :status,
        :storage_bytes,
        :subnet_id,
        :subnet_ids,
        :subnets,
        :subnetwork,
        :substitutions,
        :table_id,
        :table_reference,
        :target,
        :target_pools,
        :target_size,
        :target_tags,
        :target_vpn_gateway,
        :timeout,
        :timeout_in_minutes,
        :timeout_sec,
        :title,
        :trail_arn,
        :trail_name,
        :ttl,
        :type,
        :unhealthy_threshold,
        :update_time,
        :url_map,
        :users,
        :version,
        :version_id,
        :vpc_id,
        :vpc_zone_identifier,
        :writer_identity,
        :xpn_project_status,
        :zone,
        :zone_names,
        :zone_signing_key_algorithm,
      ].freeze

      # load the resource pack into InSpec::Resource.registry
      def self.load_resource_pack(resource_path)
        # find the libraries path in the resource pack
        if resource_path.end_with?("libraries")
          libpath = resource_path
        else
          libpath = resource_path + "/libraries"
        end
        $LOAD_PATH.push(libpath)
        # find all the classes in the libpath and require them
        # this adds them to the Inspec::Resource.registry
        Dir.glob("#{libpath}/*.rb").each do |x|
          begin
            require(x)
          rescue Exception => e # rubocop:disable Lint/RescueException AWS is blowing up for some reason
            puts e
          end
        end
        @inspec_resources = Inspec::Resource.registry.keys
      end

      # there really should be some way to get this directly from InSpec's resources
      def self.resource_properties(resource, platform)
        # remove the common methods, in theory only leaving only unique InSpec properties
        inspec_properties = Inspec::Resource.registry[resource].instance_methods - Inspec::Resource.registry[resource].methods
        inspec_properties += ADDITIONAL_COMMON_PROPERTIES
        case platform
        when "aws"
          inspec_properties -= InspecPlugins::Iggy::Platforms::AwsHelper::AWS_REMOVED_PROPERTIES[resource] unless InspecPlugins::Iggy::Platforms::AwsHelper::AWS_REMOVED_PROPERTIES[resource].nil?
        when "azure"
          inspec_properties -= InspecPlugins::Iggy::Platforms::AzureHelper::AZURE_REMOVED_PROPERTIES[resource] unless InspecPlugins::Iggy::Platforms::AzureHelper::AZURE_REMOVED_PROPERTIES[resource].nil?
        when "gcp"
          inspec_properties -= InspecPlugins::Iggy::Platforms::GcpHelper::GCP_REMOVED_PROPERTIES[resource] unless InspecPlugins::Iggy::Platforms::GcpHelper::GCP_REMOVED_PROPERTIES[resource].nil?
        end
        # get InSpec properties by method names
        inspec_properties.collect!(&:to_s)
        Inspec::Log.debug "InspecHelper.resource_properties #{resource} properties = #{inspec_properties}"

        inspec_properties
      end

      def self.tf_controls(title, generated_controls, platform)
        content = "title \"#{title}: generated by Iggy v#{Iggy::VERSION}\"\n"

        content += InspecPlugins::Iggy::Platforms::AwsHelper.tf_controls if platform.eql?("aws")

        # write all controls
        generated_controls.flatten.each do |control|
          if control.class.eql?(Inspec::Object::Control)
            content += control.to_ruby
            content += "\n\n"
          else # this is for embedded iterators in negative tests
            content += control
          end
        end
        content
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
