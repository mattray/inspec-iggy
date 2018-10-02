# encoding: UTF-8
#
# Author:: Matt Ray (<matt@chef.io>)
#
# Copyright:: 2018, Chef Software, Inc <legal@chef.io>
#

require 'inspec-iggy/inspec_helper'

describe Iggy::InspecHelper::RESOURCES do
  it 'resources' do
    expect(Iggy::InspecHelper::RESOURCES).to include('aws_vpc')
    expect(Iggy::InspecHelper::RESOURCES).to include('directory')
    expect(Iggy::InspecHelper::RESOURCES).to include('package')
  end
end

describe Iggy::InspecHelper.resource_properties('aws_vpc') do
  it { is_expected.to include('cidr_block') }
end

describe Iggy::InspecHelper.resource_properties('directory') do
  it { is_expected.to include('owner') }
end

describe Iggy::InspecHelper.resource_properties('package') do
  it { is_expected.to include('version') }
end
