# encoding: utf-8

libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'inspec-iggy/cli'
require 'inspec-iggy/version'
