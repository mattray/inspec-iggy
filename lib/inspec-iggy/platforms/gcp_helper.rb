# helpers for working with InSpec-GCP profiles

require "yaml"

module InspecPlugins::Iggy::Platforms
  class GcpHelper
    # find the additional parameters for the 'describe'
    GCP_RESOURCE_QUALIFIERS = {
      "google_bigquery_dataset" => %i{project name},
      "google_bigquery_table" => %i{project dataset name},
      "google_cloudfunctions_cloud_function" => %i{project location name},
      "google_compute_address" => %i{project location name},
      "google_compute_autoscaler" => %i{project zone name},
      "google_compute_backend_bucket" => %i{project name},
      "google_compute_backend_service" => %i{project name},
      "google_compute_disk" => %i{project name zone},
      "google_compute_firewall" => %i{project name},
      "google_compute_forwarding_rule" => %i{project region name},
      "google_compute_global_address" => %i{project name},
      "google_compute_global_forwarding_rule" => %i{project name},
      "google_compute_health_check" => %i{project name},
      "google_compute_http_health_check" => %i{project name},
      "google_compute_https_health_check" => %i{project name},
      "google_compute_image" => %i{project name},
      "google_compute_instance" => %i{project zone name},
      "google_compute_instance_group" => %i{project zone name},
      "google_compute_instance_group_manager" => %i{project zone name},
      "google_compute_instance_template" => %i{project name},
      "google_compute_network" => %i{project name},
      "google_compute_project_info" => [:project],
      "google_compute_region" => %i{project name},
      "google_compute_region_backend_service" => %i{project region name},
      "google_compute_region_instance_group_manager" => %i{project region name},
      "google_compute_route" => %i{project name},
      "google_compute_router" => %i{project region name},
      "google_compute_snapshot" => %i{project name},
      "google_compute_ssl_certificate" => %i{project name},
      "google_compute_ssl_policy" => %i{project name},
      "google_compute_subnetwork" => %i{project region name},
      "google_compute_subnetwork_iam_policy" => %i{project region name},
      "google_compute_target_http_proxy" => %i{project name},
      "google_compute_target_https_proxy" => %i{project name},
      "google_compute_target_pool" => %i{project region name},
      "google_compute_target_tcp_proxy" => %i{project name},
      "google_compute_url_map" => %i{project name},
      "google_compute_vpn_tunnel" => %i{project region name},
      "google_compute_zone" => %i{project zone},
      "google_container_cluster" => %i{project zone name},
      "google_container_node_pool" => %i{project zone cluster_name nodepool_name},
      "google_container_regional_cluster" => %i{project location name},
      "google_container_regional_node_pool" => %i{project location cluster name},
      "google_dns_managed_zone" => %i{project zone},
      "google_dns_resource_record_set" => %i{project name type managed_zone},
      "google_kms_crypto_key" => %i{project location key_ring_name name},
      "google_kms_crypto_key_iam_binding" => %i{crypto_key_url role},
      "google_kms_key_ring" => %i{project location name},
      "google_kms_key_ring_iam_binding" => %i{key_ring_url role},
      "google_logging_project_exclusion" => %i{project exclusion},
      "google_logging_project_sink" => %i{project sink},
      "google_organization" => [:display_name],
      "google_organization_policy" => %i{name constraints},
      "google_project" => [:project],
      "google_project_alert_policy" => [:policy],
      "google_project_alert_policy_condition" => %i{name filter},
      "google_project_iam_binding" => %i{project role},
      "google_project_iam_custom_role" => %i{project name},
      "google_project_logging_audit_config" => [:project],
      "google_project_metric" => %i{project metric},
      "google_pubsub_subscription" => %i{project name},
      "google_pubsub_subscription_iam_policy" => %i{project name},
      "google_pubsub_topic" => %i{project name},
      "google_pubsub_topic_iam_policy" => %i{project name},
      "google_resourcemanager_organization_policy" => %i{organization_name constraint},
      "google_service_account" => [:name],
      "google_service_account_key" => [:name],
      "google_sourcerepo_repository" => %i{project name},
      "google_sql_database_instance" => %i{project database},
      "google_storage_bucket" => [:name],
      "google_storage_bucket_acl" => %i{bucket entity},
      "google_storage_bucket_iam_binding" => %i{bucket role},
      "google_storage_bucket_object" => %i{bucket object},
      "google_storage_default_object_acl" => %i{bucket entity},
      "google_storage_object_acl" => %i{bucket object entity},
      "google_user" => [:user_key],
    }.freeze

    # the iterators for the various resource types
    GCP_RESOURCE_ITERATORS = {
      # 'google_compute_disk' => { 'iterator' => 'google_compute_disks', 'index' => 'names', 'qualifiers' => [:project, :zone] }, # false positives because instance attached disks aren't managed by Terraform
      # 'google_compute_network' => { 'iterator' => 'google_compute_networks', 'index' => 'network_names', 'qualifiers' => [:project] },
      # 'google_compute_region' => { 'iterator' => 'google_compute_regions', 'index' => 'region_names', 'qualifiers' => [:project] },
      # 'google_compute_region_instance_group_manager' => { 'iterator' => 'google_compute_region_instance_group_managers', 'index' => 'instance_group_names', 'qualifiers' => [:project, :region] }, verify it has 2 filter criteria
      # 'google_compute_route' => { 'iterator' => 'google_compute_routes', 'index' => 'names', 'qualifiers' => [:project] },
      # 'google_compute_subnetwork' => { 'iterator' => 'google_compute_subnetworks', 'index' => 'subnetwork_names', 'qualifiers' => [:project, :region] },
      # 'google_compute_zone' => { 'iterator' => 'google_compute_zones', 'index' => 'zone_names', 'qualifiers' => [:project] },
      # 'google_kms_crypto_key_iam_binding' => { 'iterator' => 'google_kms_crypto_key_iam_bindings', 'index' => 'iam_binding_roles', 'qualifiers' => [:crypto_key_url] },
      # 'google_kms_key_ring' => { 'iterator' => 'google_kms_key_rings', 'index' => 'key_ring_names', 'qualifiers' => [:project, :location] },
      # 'google_kms_key_ring_iam_binding' => { 'iterator' => 'google_kms_key_ring_iam_bindings', 'index' => 'iam_binding_roles', 'qualifiers' => [:key_ring_url] },
      # 'google_organization' => { 'iterator' => 'google_organizations', 'index' => 'names', 'qualifiers' => [] }, # organizations are not managed by Terraform
      # 'google_project' => { 'iterator' => 'google_projects', 'index' => 'project_names', 'qualifiers' => [] }, # projects are not managed by Terraform
      # 'google_project_iam_binding' => { 'iterator' => 'google_project_iam_bindings', 'index' => 'iam_binding_roles', 'qualifiers' => [:project] },
      "google_bigquery_dataset" => { "iterator" => "google_bigquery_datasets", "index" => "names", "qualifiers" => [:project] },
      "google_bigquery_table" => { "iterator" => "google_bigquery_tables", "index" => "table_references", "qualifiers" => %i{project dataset} },
      "google_cloudbuild_trigger" => { "iterator" => "google_cloudbuild_triggers", "index" => "names", "qualifiers" => [:project] },
      "google_cloudfunctions_cloud_function" => { "iterator" => "google_cloudfunctions_cloud_functions", "index" => "names", "qualifiers" => %i{project location} },
      "google_compute_autoscaler" => { "iterator" => "google_compute_autoscalers", "index" => "names", "qualifiers" => %i{project zone} },
      "google_compute_backend_bucket" => { "iterator" => "google_compute_backend_buckets", "index" => "names", "qualifiers" => [:project] },
      "google_compute_backend_service" => { "iterator" => "google_compute_backend_services", "index" => "names", "qualifiers" => [:project] },
      "google_compute_firewall" => { "iterator" => "google_compute_firewalls", "index" => "firewall_names", "qualifiers" => [:project] },
      "google_compute_forwarding_rule" => { "iterator" => "google_compute_forwarding_rules", "index" => "forwarding_rule_names", "qualifiers" => %i{project region} },
      "google_compute_health_check" => { "iterator" => "google_compute_health_checks", "index" => "names", "qualifiers" => [:project] },
      "google_compute_http_health_check" => { "iterator" => "google_compute_http_health_checks", "index" => "names", "qualifiers" => [:project] },
      "google_compute_https_health_check" => { "iterator" => "google_compute_https_health_checks", "index" => "names", "qualifiers" => [:project] },
      "google_compute_instance" => { "iterator" => "google_compute_instances", "index" => "instance_names", "qualifiers" => %i{project zone} },
      "google_compute_instance_group" => { "iterator" => "google_compute_instance_groups", "index" => "instance_group_names", "qualifiers" => %i{project zone} },
      "google_compute_instance_group_manager" => { "iterator" => "google_compute_instance_group_managers", "index" => "base_instance_names", "qualifiers" => %i{project zone} },
      "google_compute_instance_template" => { "iterator" => "google_compute_instance_templates", "index" => "names", "qualifiers" => [:project] },
      "google_compute_router" => { "iterator" => "google_compute_routers", "index" => "names", "qualifiers" => %i{project region} },
      "google_compute_snapshot" => { "iterator" => "google_compute_snapshots", "index" => "names", "qualifiers" => [:project] },
      "google_compute_ssl_certificate" => { "iterator" => "google_compute_ssl_certificates", "index" => "names", "qualifiers" => [:project] },
      "google_compute_ssl_policy" => { "iterator" => "google_compute_ssl_policies", "index" => "names", "qualifiers" => [:project] },
      "google_compute_target_http_proxy" => { "iterator" => "google_compute_target_http_proxies", "index" => "names", "qualifiers" => [:project] },
      "google_compute_target_https_proxy" => { "iterator" => "google_compute_target_https_proxies", "index" => "names", "qualifiers" => [:project] },
      "google_compute_target_pool" => { "iterator" => "google_compute_target_pools", "index" => "names", "qualifiers" => %i{project region} },
      "google_compute_target_tcp_proxy" => { "iterator" => "google_compute_target_tcp_proxies", "index" => "names", "qualifiers" => [:project] },
      "google_compute_url_map" => { "iterator" => "google_compute_url_maps", "index" => "names", "qualifiers" => [:project] },
      "google_compute_vpn_tunnel" => { "iterator" => "google_compute_vpn_tunnels", "index" => "vpn_tunnel_names", "qualifiers" => %i{project region} },
      "google_container_cluster" => { "iterator" => "google_container_clusters", "index" => "cluster_names", "qualifiers" => %i{project zone} },
      "google_container_node_pool" => { "iterator" => "google_container_node_pools", "index" => "node_pool_names", "qualifiers" => %i{project zone cluster_name} },
      "google_container_regional_cluster" => { "iterator" => "google_container_regional_clusters", "index" => "names", "qualifiers" => %i{project location} },
      "google_dns_managed_zone" => { "iterator" => "google_dns_managed_zones", "index" => "zone_names", "qualifiers" => [:project] },
      "google_dns_resource_record_set" => { "iterator" => "google_dns_resource_record_sets", "index" => "names", "qualifiers" => %i{project managed_zone} },
      "google_kms_crypto_key" => { "iterator" => "google_kms_crypto_keys", "index" => "crypto_key_names", "qualifiers" => %i{project location key_ring_name} },
      "google_logging_project_sink" => { "iterator" => "google_logging_project_sinks", "index" => "sink_names", "qualifiers" => [:project] },
      "google_project_alert_policy" => { "iterator" => "google_project_alert_policies", "index" => "policy_names", "qualifiers" => [:project] },
      "google_project_metric" => { "iterator" => "google_project_metrics", "index" => "metric_names", "qualifiers" => [:project] },
      "google_pubsub_subscription" => { "iterator" => "google_pubsub_subscriptions", "index" => "names", "qualifiers" => [:project] },
    }.freeze

    GCP_REMOVED_PROPERTIES = {
      "google_compute_firewall" => %i{creation_timestamp destination_ranges id self_link source_service_accounts source_tags target_service_accounts}, # formatted differently
      "google_compute_http_health_check" => %i{self_link id creation_timestamp}, # id: terraform has name not id, self_link: undocumented but broken, creation_timestamp api incompatibility
      "google_compute_instance" => %i{id label_fingerprint machine_type metadata min_cpu_platform zone}, # label_fingerprint, machine_type, zone api incompatibility | min_cpu_platform undefined
      "google_compute_instance_group" => [:zone], # zone api incompatibility issue
      "google_compute_forwarding_rule" => %i{backend_service ip_version network region subnetwork}, # :backend_service, :ip_version, :network, :region, :subnetwork api incompatibility
      "google_compute_target_pool" => %i{backup_pool failover_ratio id region self_link}, # api incompatibility
    }.freeze

    GCP_TRANSLATED_RESOURCE_PROPERTIES = {
      "google_compute_instance" => { "instance_id" => "id" },
    }.freeze

    # readme content
    def self.readme; end

    # inspec.yml boilerplate content from
    # inspec/lib/plugins/inspec-init/templates/profiles/gcp/inspec.yml
    def self.inspec_yml
      yml = {}
      yml["inspec_version"] = ">= 2.3.5"
      yml["depends"] = [{
        "name" => "inspec-gcp",
        "url" => "https://github.com/inspec/inspec-gcp/archive/master.tar.gz",
      }]
      yml["supports"] = [{
        "platform" => "gcp",
      }]
      yml
    end
  end
end
