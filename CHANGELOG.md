This is the current, previous and future development milestones and contains the features backlog.

# 0.1.0 #
* Initial prototype supporting a terraform.tfstate from the AWS provider and tagged profiles
* Produces a dynamic set of AWS generated controls

# 0.2.0 #
* switched to Apache v2 license
* switched to to_ruby
* rename to inspec-iggy
* switch to InSpec plugin
* moved to https://github.com/inspec/inspec-iggy

# BACKLOG #
* CloudFormation find VPC entrypoint
* ARM templates
* wrap control in a full profile for upload https://github.com/chef/inspec/tree/master/lib/bundles/inspec-init
* create a Terraform Provisioner for attaching InSpec profiles to a resource
* Generate a full profile that depends on the list of profiles from tags
* Tie tagged compliance profiles back to machines and non-machines where applicable (ie. AWS Hong Kong)
* Test with something besides AWS
* Test with more complicated tfstate files, the parsing is probably brittle
* More profile options to fill out the inspec.yml from the CLI
* Investigate InSpec packaging options
* Archived profiles
* negative testing
