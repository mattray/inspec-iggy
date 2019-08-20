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
<<<<<<< HEAD
        'aws_dynamodb_table' => 'aws_dynamo_db_table',
        'aws_autoscaling_group' => 'aws_auto_scaling_group',
=======
>>>>>>> 2b0b15d1c9eaf4d4ba689ee0135c7ce287a4b034
        'aws_v_p_c' => 'aws_vpc', # CFN
        'azurerm_resource_group' => 'azure_resource_group',
        'azurerm_virtual_machine' => 'azure_virtual_machine'
        # "azure_virtual_machine_data_disk",
        # 'aws_route' => 'aws_route_table' # needs route_table_id instead of id
      }.freeze

      def self.available_resource_qualifiers(platform)
        case platform
        when 'aws'
          InspecPlugins::Iggy::Platforms::AwsHelper::AWS_RESOURCE_QUALIFIERS
        when 'azure'
          InspecPlugins::Iggy::Platforms::AzureHelper::AZURE_RESOURCE_QUALIFIERS
        when 'gcp'
          InspecPlugins::Iggy::Platforms::GcpHelper::GCP_RESOURCE_QUALIFIERS
        end
      end

      def self.available_resource_iterators(platform)
        case platform
        when 'aws'
          InspecPlugins::Iggy::Platforms::AwsHelper::AWS_RESOURCE_ITERATORS
        when 'azure'
          InspecPlugins::Iggy::Platforms::AzureHelper::AZURE_RESOURCE_ITERATORS
        when 'gcp'
          InspecPlugins::Iggy::Platforms::GcpHelper::GCP_RESOURCE_ITERATORS
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
<<<<<<< HEAD
        # :filter, # removed because of AWS
=======
>>>>>>> 2b0b15d1c9eaf4d4ba689ee0135c7ce287a4b034
        :freeze,
        :frozen?,
        :hash,
        :inspec,
        :inspect,
        :instance_eval,
        :instance_exec,
<<<<<<< HEAD
        :iam_instance_profile, # removed because of AWS
=======
>>>>>>> 2b0b15d1c9eaf4d4ba689ee0135c7ce287a4b034
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
<<<<<<< HEAD
        :spot_price, # removed because of AWS
        :taint,
        :tainted?,
        :tag,  # removed because of AWS
        :tags, # removed because of AWS
=======
        :taint,
        :tainted?,
>>>>>>> 2b0b15d1c9eaf4d4ba689ee0135c7ce287a4b034
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
<<<<<<< HEAD
        :user_data,
=======
>>>>>>> 2b0b15d1c9eaf4d4ba689ee0135c7ce287a4b034
        :yield_self
      ].freeze

      # properties are often dynamically generated, making it hard to determine
      # their existence without instantiating them. Because of this, we will
      # maintain a manual list for now
      ADDITIONAL_COMMON_PROPERTIES = [
        # :backend_service, # documented but undefined
        # :id, #disabled for GCP
        # :ip_version, # documented but undefined
        # :network, # documented but undefined
        # :subnetwork, # documented but undefined
        :addons_config,
        :address_type,
        :address,
        :aggregation_alignment_period,
        :aggregation_cross_series_reducer,
        :aggregation_per_series_aligner,
<<<<<<< HEAD
        :allow__check_criteria, # added for inspec-aws
        :allowed,
        :allow_in, # added for inspec-aws
        :allow_in_only, # added for inspec-aws
        :allow_out, # added for inspec-aws
        :allow_out_only, # added for inspec-aws
=======
        :allowed,
>>>>>>> 2b0b15d1c9eaf4d4ba689ee0135c7ce287a4b034
        :archive_size_bytes,
        :auto_create_subnetworks,
        :available_cpu_platforms,
        :available_memory_mb,
        :backend_service,
        :backup_pool,
        :base_instance_name,
<<<<<<< HEAD
        :be_allow_in, # added for inspec-aws
        :be_allow_out, # added for inspec-aws
=======
>>>>>>> 2b0b15d1c9eaf4d4ba689ee0135c7ce287a4b034
        :can_ip_forward,
        :check_interval_sec,
        :cluster_ipv4_cidr,
        :combiner,
        :common_instance_metadata,
        :condition_threshold_value,
        :conditions,
        :config,
        :cpu_platform,
        :create_time_date,
        :create_time,
        :creation_record,
        :creation_timestamp_date,
        :creation_timestamp,
        :crypto_key_name,
        :crypto_key_url,
        :current_actions,
        :current_master_version,
        :current_node_count,
        :current_node_version,
        :custom_features,
        :dataset_id,
        :dataset,
        :default_exempted_members,
        :default_service_account,
        :default_types,
        :deletion_protection,
        :description,
        :detailed_status,
        :direction,
        :disabled,
        :disk_encryption_key,
        :disk_size_gb,
        :disks,
        :display_name,
        :dns_name,
        :dnssec_config,
        :enabled_features,
        :enabled,
        :endpoint,
        :entry_point,
        :environment_variables,
        :etag,
        :expire_time,
        :failover_ratio,
        :family,
        :filename,
<<<<<<< HEAD
=======
        :filter,
>>>>>>> 2b0b15d1c9eaf4d4ba689ee0135c7ce287a4b034
        :fingerprint,
        :friendly_name,
        :gateway_address,
        :guest_accelerators,
        :guest_os_features,
<<<<<<< HEAD
        :group_name,
=======
>>>>>>> 2b0b15d1c9eaf4d4ba689ee0135c7ce287a4b034
        :health_check,
        :healthy_threshold,
        :host,
        :ignored_files,
        :ike_version,
        :included_files,
        :included_permissions,
        :initial_cluster_version,
        :initial_node_count,
        :instance_group_urls,
        :instance_group,
        :instance_template,
        :ip_address,
        :ip_cidr_range,
        :ip_protocol,
        :ip_version,
        :key_ring_name,
        :key_ring_url,
        :key_signing_key_algorithm,
        :kind,
        :kms_key_name,
        :label_fingerprint,
        :label_value_by_key,
        :labels_keys,
        :labels_values,
        :labels,
        :last_attach_timestamp,
        :last_detach_timestamp,
        :last_modified_time,
        :legacy_abac,
        :licenses,
        :lifecycle_state,
        :load_balancing_scheme,
        :local_traffic_selector,
        :location,
        :logging_service,
        :machine_type,
        :managed_zone,
        :management,
        :master_auth,
        :members,
        :metadata_keys,
        :metadata_value_by_key,
        :metadata_values,
        :metadata,
        :min_cpu_platform,
        :monitoring_service,
        :mutation_record,
        :name_servers,
        :family,
        :filename,
<<<<<<< HEAD
        # :filter, - removed for AWS
=======
        :filter,
>>>>>>> 2b0b15d1c9eaf4d4ba689ee0135c7ce287a4b034
        :fingerprint,
        :friendly_name,
        :gateway_address,
        :guest_accelerators,
        :guest_os_features,
        :health_check,
        :healthy_threshold,
        :host,
        :ignored_files,
        :ike_version,
        :included_files,
        :included_permissions,
        :initial_cluster_version,
        :initial_node_count,
        :instance_group_urls,
        :instance_group,
        :instance_template,
        :ip_address,
        :ip_cidr_range,
        :ip_protocol,
        :ip_version,
        :key_ring_name,
        :key_ring_url,
        :key_signing_key_algorithm,
        :kind,
        :kms_key_name,
        :label_fingerprint,
        :label_value_by_key,
        :labels_keys,
        :labels_values,
        :labels,
        :last_attach_timestamp,
        :last_detach_timestamp,
        :last_modified_time,
        :legacy_abac,
        :licenses,
        :lifecycle_state,
        :load_balancing_scheme,
        :local_traffic_selector,
        :location,
        :logging_service,
        :machine_type,
        :managed_zone,
        :management,
        :master_auth,
        :members,
        :metadata_keys,
        :metadata_value_by_key,
        :metadata_values,
        :metadata,
        :min_cpu_platform,
        :monitoring_service,
        :mutation_record,
        :name_servers,
<<<<<<< HEAD
=======
        :name,
>>>>>>> 2b0b15d1c9eaf4d4ba689ee0135c7ce287a4b034
        :named_ports,
        :network_interfaces,
        :network,
        :next_hop_gateway,
        :next_hop_instance,
        :next_hop_ip,
        :next_hop_network,
        :next_hop_vpn_tunnel,
        :next_rotation_time_date,
        :next_rotation_time,
        :node_config,
        :node_ipv4_cidr_size,
        :node_pools,
        :num_bytes,
        :num_long_term_bytes,
        :num_rows,
        :output_version_format,
        :parent,
        :peer_ip,
        :physical_block_size_bytes,
        :port_range,
        :port,
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
        :protocol,
        :proxy_header,
        :purpose,
        :quic_override,
        :quotas,
        :raw_disk,
        :raw_key,
        :region_name,
        :region,
        :remote_traffic_selector,
        :request_path,
        :rotation_period,
        :router,
        :routing_config,
        :runtime,
        :scheduling,
        :self_link,
        :service_account_email,
        :service_accounts,
        :service,
        :services_ipv4_cidr,
        :session_affinity,
        :sha256,
        :shared_secret_hash,
        :shared_secret,
        :size_gb,
        :source_archive_url,
        :source_disk,
        :source_image_encryption_key,
        :source_image_id,
        :source_image,
        :source_ranges,
        :source_snapshot_encryption_key,
        :source_snapshot_id,
        :source_snapshot,
        :source_type,
        :source_upload_url,
        :ssl_certificates,
        :ssl_policy,
        :stage,
        :start_restricted,
        :status,
        :storage_bytes,
        :subnetwork,
        :substitutions,
        :table_id,
        :table_reference,
<<<<<<< HEAD
        # :tag, - removed for AWS
        # :tags,  - removed for AWS
=======
        :tags,
>>>>>>> 2b0b15d1c9eaf4d4ba689ee0135c7ce287a4b034
        :target_pools,
        :target_size,
        :target_tags,
        :target_vpn_gateway,
        :target,
        :timeout_sec,
        :timeout,
        :title,
        :ttl,
        :type,
        :unhealthy_threshold,
        :update_time,
        :url_map,
        :users,
        :version_id,
        :version,
        :writer_identity,
        :xpn_project_status,
        :zone_signing_key_algorithm,
        :zone
      ].freeze

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
          rescue Exception =>e # rubocop:disable Lint/RescueException AWS is blowing up for some reason
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
        generated_controls.flatten.each do |control|
          if control.class.eql?(Inspec::Control)
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
