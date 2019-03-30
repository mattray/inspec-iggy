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

      def self.fetch(url)
        temp_file = url
        # if this is a file, just return it
        # retrieve the file into a temp_file
        # do all urls start with http:// https://
        # is s3:// a thing?
        # how else do CFN and Terraform store this?
        #  absolutename = File.absolute_path(file) will be broken for remote files
        return temp_file
      end

    end
  end
end
