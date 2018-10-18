# encoding: UTF-8
#
# Author:: Matt Ray (<matt@chef.io>)
#
# Copyright:: 2018, Chef Software, Inc <legal@chef.io>
#

require 'helper'
require 'inspec-iggy/version'

module IggyUnitTests
  class Version < Minitest::Test
    def test_should_have_a_version_constant_defined
      assert_kind_of(String, InspecPlugins::Iggy::VERSION)
    end
  end
end
