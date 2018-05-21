# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "inspec-iggy/version"

Gem::Specification.new do |spec|
  spec.name        = "inspec-iggy"
  spec.version     = Iggy::VERSION
  spec.authors     = ["Matt Ray"]
  spec.email       = ["matt@chef.io"]
  spec.summary     = "InSpec plugin to generate InSpec compliance profiles from Terraform."
  spec.description = "Generate InSpec compliance profiles from Terraform by tagging instances and mapping Terraform to InSpec."
  spec.homepage    = "https://github.com/inspec/inspec-iggy"
  spec.license     = "Apache-2.0"

  spec.files = %w{
    README.md inspec-iggy.gemspec Gemfile
  } + Dir.glob(
    "{bin,docs,examples,lib,tasks,test}/**/*", File::FNM_DOTMATCH
  ).reject { |f| File.directory?(f) }

  spec.require_paths = ["lib"]

  spec.add_dependency "inspec", ">=2.0", "<3.0.0"
end
