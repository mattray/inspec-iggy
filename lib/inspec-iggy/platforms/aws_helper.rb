# helpers for working with InSpec-AWS profiles

require "yaml"

module InspecPlugins::Iggy::Platforms
  class AwsHelper
    # find the additional parameters for the 'describe'.
    # NOTE: the first entry is going to map to the 'id' from the .tfstate file
    AWS_RESOURCE_QUALIFIERS = {
      "aws_ec2_instance" => %i{instance_id},
      "aws_elb" => %i{load_balancer_name},
      "aws_security_group" => %i{group_id vpc_id},
      "aws_subnet" => %i{subnet_id},
      "aws_vpc" => %i{vpc_id},
    }.freeze

    # the iterators for the various resource types
    AWS_RESOURCE_ITERATORS = {
      "aws_ec2_instance" => { "iterator" => "aws_ec2_instances", "index" => "instance_ids", "qualifiers" => [:vpc_id]},
      "aws_elb" => { "iterator" => "aws_elbs", "index" => "load_balancer_names", "qualifiers" => [:vpc_id]},
      "aws_security_group" => { "iterator" => "aws_security_groups", "index" => "group_ids", "qualifiers" => [:vpc_id]},
      "aws_subnet" => { "iterator" => "aws_subnets", "index" => "subnet_ids", "qualifiers" => [:vpc_id]},
      "aws_vpc" => { "iterator" => "aws_vpcs", "index" => "vpc_ids"},
    }.freeze

    AWS_REMOVED_PROPERTIES = {
      "aws_elb" => %i{health_check security_groups}, # not sure how to test this yet
      "aws_ec2_instance" => %i{security_groups}, # not sure how to test this yet
    }.freeze

    AWS_TRANSLATED_RESOURCE_PROPERTIES = {
      "aws_elb" => { "name" => "load_balancer_name" },
      "aws_security_group" => { "name" => "group_name" },
    }.freeze

    # Terraform boilerplate controls/controls.rb content
    def self.tf_controls
      "\n"
    end

    # readme content
    def self.readme; end

    # inspec.yml boilerplate content from
    # inspec/lib/plugins/inspec-init/templates/profiles/aws/inspec.yml
    def self.inspec_yml
      yml = {}
      yml["inspec_version"] = "~> 4"
      yml["depends"] = [{
        "name" => "inspec-aws",
        "url" => "https://github.com/inspec/inspec-aws/archive/master.tar.gz",
      }]
      yml["supports"] = [{
        "platform" => "aws",
      }]
      yml
    end
  end
end
