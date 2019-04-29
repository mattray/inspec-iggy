This is the current, previous and future development milestones and contains the features backlog.

# 0.1.0 #
* Initial prototype supporting a terraform.tfstate from the AWS provider and tagged profiles
* Produces a dynamic set of AWS generated controls

# 0.2.0 #
* switched to Apache v2 license
* switched to to_ruby (Christoph Hartmann)
* rename to inspec-iggy
* switched to InSpec plugin
* moved to https://github.com/inspec/inspec-iggy
* published to Rubygems

# 0.3.0 #
* CloudFormation support through the stack-name entry
* Wrap control in a full profile for upload
* document Linux Omnibus installer usage
* More profile options to fill out the inspec.yml from the CLI
* .rubocop.yml synced to InSpec v2.2.79 and Rubocop 0.55
* Switch to Inspec::BaseCLI for the helper methods
* use new plugin include path (for old v1 plugins) @chris-rock
* allowing for multiple modules to be included in generate output @devoptimist

# 0.4.0 #
* Primarily @clintoncwolfe, refactoring and modifying for Plugin API
* Overhaul to match InSpec Plugin API2/InSpec v3.0
* Place code under InspecPlugins::Iggy namespace
* Re-Organize tests
* Add tests for testing plugin interface
* Add tests for testing user functionality
* Expand Rakefile

# 0.5.0
* provide DESIGN.md explaining the organization of the code
* disabled the `inspec terraform extract` subcommand until a more sustainable solution is determined
* moved back to https://github.com/mattray/inspec-iggy as a community plugin
* Sync and upgrade InSpec's .rubocop.yml and associated code cleanups
* rename lib/inspec-iggy/profile.rb to profile_helper.rb
* refactor out JSON parsing into file_helper.rb
* switch from 'eq' to 'cmp' comparators https://github.com/mattray/inspec-iggy/issues/23
* enable minimal Azure support. This needs to be refactored.
* add support for remote .tfstate and .cfn files via Iggy::FileHelper.fetch https://github.com/mattray/inspec-iggy/issues/3

# BACKLOG #
* document Windows Omnibus installer usage
* how are we going to preemptively know what's in the various resource packs?
  Perhaps load all Resources individually to map out their properties?
  Big translation helper hash?
* enable GCP support
* Habitat packaging
* Rubocop the generated profiles
* enable negative testing to look for things not covered by Terraform
* ARM templates
* translate properties from cfn/tf->inspec
* Terraform
  * More Terraform back-ends https://www.terraform.io/docs/backends/types/index.html
  * do we want to generate inspec coverage for the tfplan?
  * Terraform 0.12 support
* restore extract functionality
  * create a Terraform Provisioner for attaching InSpec profiles to a resource
  * Tie tagged compliance profiles back to machines and non-machines where applicable (ie. AWS Hong Kong)
* InSpec 4.0 will likely break stuff
