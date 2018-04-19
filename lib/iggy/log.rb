#
# Author:: Matt Ray (<matt@chef.io>)
#
# Copyright:: 2018, Chef Software, Inc <legal@getchef.com>
#

require "mixlib/log"

module Iggy
  class Log
    extend Mixlib::Log

    # # not quite ready for timestamps
    # Mixlib::Log::Formatter.show_time = false
  end
end
