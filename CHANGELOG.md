This is the current, previous and future development milestones and contains the features backlog.

# 0.1.0 #
* Initial prototype supporting a terraform.tfstate from the AWS provider and tagged profiles
* Only produces a dynamic set of AWS generated controls and a list of profiles

# BACKLOG #
* InSpec properties can be tested by checking the original TF files for the expectations
* Generate a full profile that depends on the list of profiles
* Tie tagged compliance profiles back to machines
* Support multiple compliance tags
* Test with something besides AWS
* Test with more complicated tfstate files, the parsing is probably brittle
* More profile options to fill out the inspec.yml from the CLI
* Investigate InSpec packaging options
* Archived profiles
* CloudFormation
* ARM templates
