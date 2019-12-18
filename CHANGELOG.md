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

# 0.6.0
* InSpec 4.0 support added
* enable AWS, Azure, and GCP platform and resource pack support
* `inspec terraform negative` was added, providing negative coverage testing
* unit tests were broken by updates in InSpec and fixed. Functional and integration tests were disabled for now.
* switch to Chefstyle like InSpec and Chefstyle the generated controls

# 0.7.0 (The SysAdvent demo Release)
* added 'inspec iggy' subcommand for displaying help and version
* Terraform 0.12 support
* Restored initial AWS support, minimal testing
* aws_ec2_instance, aws_elb, aws_security_group, aws_subnet, aws_vpc
* [Terraform AWS Provider Two Tier demo](https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/two-tier)

# 0.8.0 (Terraform AWS demos release)
* make platform and resourcepack required
* aws_alb, aws_cloudformation_stack, aws_cloudtrail_trail, aws_route_table added without testing, expect issues
* [Terraform AWS Provider ELB demo](https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/)
* create new InSpec tests to validate the generated reports to look for regressions as we change out the property mapping. It's too manual and fragile.

# NEXT
* Restore and re-test AWS, Azure, GCP from resource packs
* document inspec with a reporter to push the reports into Automate
* document uploading profiles to Automate and creating scan jobs via API
* document/specify inspec-aws https://github.com/inspec/inspec-aws/releases
* clean up deprecation warnings

# BACKLOG #
* allow disabling of individual negative tests from CLI?
* additional attributes (ie. vpc_id) passed via inputs?
* allow passing alternate source of depends profiles
* ARM templates
* CloudFormation can be JSON or YAML
* add negative testing for CloudFormation
* document Windows Omnibus installer usage
* Habitat packaging
* Terraform
  * More Terraform back-ends https://www.terraform.io/docs/backends/types/index.html
  * do we want to generate inspec coverage for the tfplan?
* restore extract functionality
  * create a Terraform Provisioner for attaching InSpec profiles to a resource
  * Tie tagged compliance profiles back to machines and non-machines where applicable (ie. AWS Hong Kong)
