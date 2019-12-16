# encoding: UTF-8
#
# Author:: Matt Ray (<matt@chef.io>)
#
# Copyright:: 2018, Chef Software, Inc <legal@chef.io>
#
require "helper"

require "inspec-iggy/inspec_helper"

module IggyUnitTests
  class InSpecResources < Minitest::Test

    def known_resources
      {
        # List some resources we expect to heve
        # name => an expected property
        "aws_vpc" => "cidr_block",
        "directory" => "owner",
        "package" => "version",
      }
    end

    def test_it_should_list_resources
      known_resources.each_key do |resource_name|
        assert_includes(InspecPlugins::Iggy::InspecHelper::RESOURCES, resource_name)
      end
    end

    def test_it_should_know_resource_properties
      known_resources.each do |resource_name, property|
        assert_includes(InspecPlugins::Iggy::InspecHelper.resource_properties(resource_name), property)
      end
    end
  end
end
