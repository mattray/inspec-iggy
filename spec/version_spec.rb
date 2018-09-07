# encoding: UTF-8
#
# Author:: Matt Ray (<matt@chef.io>)
#
# Copyright:: 2018, Chef Software, Inc <legal@chef.io>
#

require 'inspec-iggy'

describe Iggy do
  it 'should have a version constant defined' do
    expect(Iggy::VERSION).to be_a_kind_of(String)
  end
end
