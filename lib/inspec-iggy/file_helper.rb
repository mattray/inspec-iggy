# helper methods for retrieving and parsing files

require 'json'

module InspecPlugins
  module Iggy
    class FileHelper
      # boilerplate JSON parsing
      def self.parse_json(file)
        Inspec::Log.debug "Iggy::FileHelper.parse_json file = #{file}"
        begin
          unless File.file?(file)
            STDERR.puts "ERROR: #{file} is an invalid file, please check your path."
            exit(-1)
          end
          JSON.parse(File.read(file))
        rescue JSON::ParserError => e
          STDERR.puts e.message
          STDERR.puts "ERROR: Parsing error in #{file}."
          exit(-1)
        end
      end
    end
  end
end
