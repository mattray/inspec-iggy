# helper methods for retrieving and parsing files

require "json"
require "open-uri"

module InspecPlugins
  module Iggy
    class FileHelper
      # boilerplate JSON parsing
      def self.parse_json(file)
        Inspec::Log.debug "Iggy::FileHelper.parse_json file = #{file}"
        lfile = fetch(file)
        begin
          unless File.file?(lfile)
            STDERR.puts "ERROR: #{lfile} is an invalid file, please check your path."
            exit(-1)
          end
          JSON.parse(File.read(lfile))
        rescue JSON::ParserError => e
          STDERR.puts e.message
          STDERR.puts "ERROR: Parsing error in #{lfile}."
          exit(-1)
        end
      end

      def self.fetch(url)
        # if this is a file, just return it
        return url if File.exist?(url)

        begin
          URI.parse(url).open
        rescue NoMethodError => e
          STDERR.puts e.message
          STDERR.puts "ERROR: Unable to open file #{url}"
          exit(-1)
        rescue OpenURI::HTTPError => e
          STDERR.puts e.message
          STDERR.puts "ERROR: Parsing error from URL #{url}"
          exit(-1)
        end
      end
    end
  end
end
