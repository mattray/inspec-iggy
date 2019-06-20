# Design

This document attempts to explain the organization of the InSpec-Iggy code and how to extend it as necessary. Because Iggy is an InSpec plugin, it tries to follow InSpec closely with regards to versions, style, and tooling. Links to the source code are given because there may be additional documentation within the files.

# Files

* [CHANGELOG.md](#changelog)
* [inspec-iggy.gemspec](#gemspec)
* [Gemfile](#gemfile)
* [.rubocop.yml](#rubocop)
* [lib/inspec-iggy.rb](#iggy)
* [lib/inspec-iggy/plugin.rb](#plugin)
* [lib/inspec-iggy/terraform/cli_command.rb](#tf_cli)
* [lib/inspec-iggy/terraform/parser.rb](#tf_parse)
* [lib/inspec-iggy/cloudformation/cli_command.rb](#cfn_cli)
* [lib/inspec-iggy/cloudformation/parser.rb](#cfn_parse)
* [lib/inspec-iggy/inspec_helper.rb](#inspec_helper)
* [lib/inspec-iggy/profile_helper.rb](#profile_helper)
* [lib/inspec-iggy/version.rb](#version)

## [CHANGELOG.md](CHANGELOG.md)<a name="changelog"/>

Has the rough feature set by each release but also contains the BACKLOG for the project, ideas considered but not yet implemented.

## [inspec-iggy.gemspec](inspec-iggy.gemspec)<a name="gemspec"/>

This is where metadata for the Gem goes. We have also pinned the version of InSpec to between 2.3 and less than 5 to prevent breaking changes.

## [Gemfile](Gemfile)<a name="gemfile"/>

The source of the gems and additional gemsets for use with Bundler (ie. `test`).

## [.rubocop.yml](.rubocop.yml)<a name="rubocop"/>

Tracks against InSpec's settings for code style, currently using 0.49.1 with [Chefstyle](https://github.com/chef/chefstyle).

## [lib/inspec-iggy.rb](lib/inspec-iggy.rb)<a name="iggy"/>

This is the "entry point" for InSpec to load if it thinks the plugin is installed. The *only* thing this file should do is setup the load path, then load the plugin definition file.

## [lib/inspec-iggy/plugin.rb](lib/inspec-iggy/plugin.rb)<a name="plugin"/>

Plugin Definition file. The purpose of this file is to declare to InSpec what plugin_types (capabilities) are included in this plugin, and provide hooks that will load them as needed. It is important that this file load successfully and *quickly*. The plugin's functionality may never be used on this InSpec run; so we keep things fast and light by only loading heavy things when they are needed.

The entry points for the `cli_command`s for `:terraform` and `:cloudformation` are here. If you were to add another format this is the place to declare that.

# Terraform<a name="tf"/>

## [lib/inspec-iggy/terraform/cli_command.rb](lib/inspec-iggy/terraform/cli_command.rb)<a name="tf_cli"/>

The `inspec terraform` CLI command and options. Given this is a Thor CLI, the `desc` and `subcommand_desc` provide help at the CLI. The `option`s hash is used to define documentation and settings for allowed subcommand options. Each method (`generate` and `extract`) is turned into further subcommands (ie. `inspec terraform generate`). The `extract` command has been disabled until a better solution is available.

Within the `generate` method the following block:

    generated_controls = InspecPlugins::Iggy::Terraform::Parser.parse_generate(options[:tfstate])

calls into the [Terraform tfstate file parser](#tf_parse) which returns the InSpec controls found by mapping Terraform resources to InSpec resources.

    printable_controls = InspecPlugins::Iggy::InspecHelper.tf_controls(options[:title], generated_controls)

calls into the [inspec helper](#inspec_helper) to produce the inspec controls to include within the profile.

    inspecplugins::iggy::profile.render_profile(self, options, options[:tfstate], printable_controls)

calls into the [profile renderer](#profile_helper).

## [lib/inspec-iggy/terraform/parser.rb](lib/inspec-iggy/terraform/parser.rb)<a name="tf_parse"/>

This class parses the passed Terraform .tfstate files. The `parse_generate` method is the standard interface for parsing, it calls into the private `parse_tfstate` method which reads the actual JSON.

The parsed Terraform JSON has a `modules` array of `resources` which are then mapped to the appropriate InSpec Resources. The [TRANSLATED_RESOURCES](#inspec_helper) provide a mapping of Terraform resources that do not match the InSpec equivalent. Controls are generated for matched resources and if the InSpec properties match the named Terraform resource attributes tests are added. The generated InSpec controls are returned.

The `parse_extract` command has been disabled until it can be properly refactored.

# CloudFormation<a name="cfn"/>

## [lib/inspec-iggy/cloudformation/cli_command.rb](lib/inspec-iggy/cloudformation/cli_command.rb)<a name="cfn_cli"/>

The CFN `cli_command.rb` is similar to the [terraform/cli_command.rb](#tf_cli). It requires a `:stack` as an option, because it will dynamically generate the InSpec profile from the launched CloudFormation stack in conjunction with the template.

## [lib/inspec-iggy/cloudformation/parser.rb](lib/inspec-iggy/cloudformation/parser.rb)<a name="cfn_parse"/>

The CFN parser is very similar to the [terraform/parser.rb](#tf_parse), parsing a JSON template file and iterating over the 'Resources'.

# Helpers

## [lib/inspec-iggy/file_helper.rb](lib/inspec-iggy/file_helper.rb)<a name="file_helper"/>

Helper class that parses JSON input files and handles errors.

## [lib/inspec-iggy/inspec_helper.rb](lib/inspec-iggy/inspec_helper.rb)<a name="inspec_helper"/>

Constants and helpers for working with InSpec. The full list of available InSpec Resources are provided by the `RESOURCES` array. Resources that do not map cleanly are provided by the `TRANSLATED_RESOURCES` hash. There are very few mismatches because both tools use the SDKs provided by the same vendors.

The `resources_properties` method returns the unique InSpec Resource properties of the passed resource. The `COMMON_PROPERTIES` array is a hack used to find the unique InSpec properties from overlapping class methods.

The method `tf_controls` provides the content for the controls file for Terraform subcommand.

The `cfn_controls` method provides the AWS API calls to dynamically check the passed CloudFormation stack and provide the content for the controls file.

## [lib/inspec-iggy/profile_helper.rb](lib/inspec-iggy/profile_helper.rb)<a name="profile_helper"/>

Helper class to render a full InSpec profile with a `README.md`, `inspec.yml`, and the generated `controls/controls.rb` populated from the parsed input file and the CLI options provided.

## [lib/inspec-iggy/version.rb](lib/inspec-iggy/version.rb)<a name="version"/>

Tracks the version of InSpec-Iggy.

# Platform Support

## Terraform

For InSpec-Iggy to work, you must have both Terraform and InSpec support for your platform. This is because it maps Terraform resources to InSpec resources. If there's not an InSpec plugin for the platform, there won't be any resources generated.

If you have working InSpec and Terraform support, you will want to run with

    inspec terraform generate -t terraform.tfstate --name DEBUG --debug

and look for messages with `Iggy::Terraform.parse_generate` to see what is being `SKIPPED`, `TRANSLATED` or `MATCHED`. You may want to drop a `pry` debugging breakpoint within the [Terraform parser](#tf_parse) `parse_generate` method to see what is in the JSON versus what InSpec resources.

If you are not getting `MATCHED` `tf_res_type` resources and all `SKIPPED`, they are most likely not in the `InspecPlugins::Iggy::InspecHelper::RESOURCES`. The `TRANSLATED_RESOURCES` within the [inspec_helper.rb](#inspec_helper) may need to be updated to map `tf_res_type`s to what is in InSpec.

At this point there are not mappings for InSpec properties to Terraform attributes. If this is an issue an additional hash of resources and the attribute mapping could be added to the [inspec_helper.rb](#inspec_helper)) in the future.

## Alternate Formats

If you want to add support for another format (ie. ARM templates or something similar), follow the examples of the [Terraform](#tf) and [CloudFormation](#cfn) support. You will start by adding a new `cli_command` to the [lib/inspec-iggy/plugin.rb](#plugin). You will need a `cli_command.rb` and `parser.rb` implementing the appropriate classes and methods.
