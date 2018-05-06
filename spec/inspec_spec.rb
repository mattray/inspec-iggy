# encoding: UTF-8
#
# Author:: Matt Ray (<matt@chef.io>)
#
# Copyright:: 2018, Chef Software, Inc <legal@chef.io>
#

require "iggy"

describe Iggy::Inspec::RESOURCES do
  it "resources" do
    expect(Iggy::Inspec::RESOURCES).to include("aws_vpc")
    expect(Iggy::Inspec::RESOURCES).to include("directory")
    expect(Iggy::Inspec::RESOURCES).to include("package")
  end
end

describe Iggy::Inspec.resource_properties("aws_vpc") do
  it { is_expected.to include("cidr_block") }
end

describe Iggy::Inspec.resource_properties("directory") do
  it { is_expected.to include("owner") }
end

describe Iggy::Inspec.resource_properties("package") do
  it { is_expected.to include("version") }
end

# describe Iggy::Inspec.print_controls do
#   it "output" do
#   end
# end
