# coding: utf-8
lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "inspec-iggy/version"

Gem::Specification.new do |spec|
  spec.name        = "inspec-iggy"
  spec.version     = InspecPlugins::Iggy::VERSION
  spec.authors     = ["Matt Ray"]
  spec.email       = ["matt@chef.io"]
  spec.summary     = "InSpec plugin to generate InSpec compliance profiles from Terraform and CloudFormation."
  spec.description = "InSpec plugin to generate InSpec profiles from Terraform and CloudFormation to ensure automatic compliance coverage."
  spec.homepage    = "https://github.com/mattray/inspec-iggy"
  spec.license     = "Apache-2.0"

  spec.files = %w{
    README.md inspec-iggy.gemspec Gemfile
  } + Dir.glob(
    "{bin,docs,examples,lib,tasks}/**/*", File::FNM_DOTMATCH
  ).reject { |f| File.directory?(f) }

  spec.require_paths = ["lib"]

  spec.add_dependency "inspec", ">=2.3", "<5"
end
