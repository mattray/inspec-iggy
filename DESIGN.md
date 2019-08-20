# Design

This document attempts to explain the organization of the InSpec-Iggy code and how to extend it as necessary. Because Iggy is an InSpec plugin, it tries to follow InSpec closely with regards to versions, style, and tooling. Links to the source code are given because there may be additional documentation within the files.

# Files

* [.rubocop.yml](#rubocop)
* [CHANGELOG.md](#changelog)
* [Gemfile](#gemfile)
* [inspec-iggy.gemspec](#gemspec)
* [lib/inspec-iggy.rb](#iggy)
* [lib/inspec-iggy/plugin.rb](#plugin)
* [lib/inspec-iggy/file_helper.rb](#ile_helper)
* [lib/inspec-iggy/inspec_helper.rb](#inspec_helper)
* [lib/inspec-iggy/profile_helper.rb](#profile_helper)
* [lib/inspec-iggy/version.rb](#version)
* [lib/inspec-iggy/platforms/aws_helper.rb](#aws_helper)
* [lib/inspec-iggy/platforms/azure_helper.rb](#azure_helper)
* [lib/inspec-iggy/platforms/gcp_helper.rb](#gcp_helper)
* [lib/inspec-iggy/terraform/cli_command.rb](#tf_cli)
* [lib/inspec-iggy/terraform/generate.rb](#tf_generate)
* [lib/inspec-iggy/terraform/negative.rb](#tf_negative)
* [lib/inspec-iggy/cloudformation/cli_command.rb](#cfn_cli)
* [lib/inspec-iggy/cloudformation/generate.rb](#cfn_generate)

## [.rubocop.yml](.rubocop.yml)<a name="rubocop"/>

Tracks against InSpec's settings for code style, currently using 0.49.1 with [Chefstyle](https://github.com/chef/chefstyle).

## [CHANGELOG.md](CHANGELOG.md)<a name="changelog"/>

Has the rough feature set by each release but also contains the BACKLOG for the project, ideas considered but not yet implemented.

## [Gemfile](Gemfile)<a name="gemfile"/>

The source of the gems and additional gemsets for use with Bundler (ie. `test`).

## [inspec-iggy.gemspec](inspec-iggy.gemspec)<a name="gemspec"/>

This is where metadata for the Gem goes. We have also pinned the version of InSpec to between 2.3 and less than 5 to prevent breaking changes.

## [lib/inspec-iggy.rb](lib/inspec-iggy.rb)<a name="iggy"/>

This is the "entry point" for InSpec to load if it thinks the plugin is installed. The *only* thing this file should do is setup the load path, then load the plugin definition file.

## [lib/inspec-iggy/plugin.rb](lib/inspec-iggy/plugin.rb)<a name="plugin"/>

Plugin Definition file. The purpose of this file is to declare to InSpec what plugin_types (capabilities) are included in this plugin, and provide hooks that will load them as needed. It is important that this file load successfully and *quickly*. The plugin's functionality may never be used on this InSpec run; so we keep things fast and light by only loading heavy things when they are needed.

The entry points for the `cli_command`s for `:terraform` and `:cloudformation` are here. If you were to add another format this is the place to declare that.

# Helpers

## [lib/inspec-iggy/file_helper.rb](lib/inspec-iggy/file_helper.rb)<a name="file_helper"/>

Helper class that parses JSON input files and handles errors.

## [lib/inspec-iggy/inspec_helper.rb](lib/inspec-iggy/inspec_helper.rb)<a name="inspec_helper"/>

Constants and helper methods for working with InSpec.

### Constants

* `TRANSLATED_RESOURCES`: Resources that do not map cleanly are provided by the `TRANSLATED_RESOURCES` hash. There are very few mismatches because both tools use the SDKs provided by the same vendors.
* `REMOVED_COMMON_PROPERTIES`: The common methods for each Resource, properties will not be checked for these methods.
* `ADDITIONAL_COMMON_PROPERTIES`: Because InSpec properties are often dynamically generated, it is hard to determine their existence without instantiating them. Because of this, we maintain a manual list of properties to check for.

### Helper Methods

* `available_resources`: The list of currently available InSpec Resources.
* `load_resource_pack(resource_path)`: Adds a resource pack's Resources to the `available_resources`.
* `available_resource_qualifiers(platform)`: The available qualifers for the Describe block within the Controls generated for a particular resource.
* `available_resource_iterators(platform)`: The iterators available for resources, also provides the qualifiers for those iterators. Used for iterating over negative coverage.
* `tf_controls`: provides the content for the controls file for Terraform subcommand.
* `cfn_controls`: provides the AWS API calls to dynamically check the passed CloudFormation stack and provide the content for the controls file.

## [lib/inspec-iggy/profile_helper.rb](lib/inspec-iggy/profile_helper.rb)<a name="profile_helper"/>

Helper class to render a full InSpec profile with a `README.md`, `inspec.yml`, and the generated `controls/generated.rb` populated from the parsed input file and the CLI options provided.

## [lib/inspec-iggy/version.rb](lib/inspec-iggy/version.rb)<a name="version"/>

Tracks the version of InSpec-Iggy.

# Platform Helpers

## [lib/inspec-iggy/platforms/aws_helper.rb](lib/inspec-iggy/platforms/aws_helper.rb)<a name="aws_helper"/>
## [lib/inspec-iggy/platforms/azure_helper.rb](lib/inspec-iggy/platforms/azure_helper.rb)<a name="azure_helper"/>
## [lib/inspec-iggy/platforms/gcp_helper.rb](lib/inspec-iggy/platforms/gcp_helper.rb)<a name="gcp_helper"/>

The platform helpers provide constants used by the [inspec_helper.rb](#inspec_helper) for translating and filtering resources, their iterators and qualifiers. They also provide methods used by the [profile_helper.rb]((#profile_helper)) to render the platform-specific instructions for the generated InSpec profiles.

# Terraform<a name="tf"/>

## [lib/inspec-iggy/terraform/cli_command.rb](lib/inspec-iggy/terraform/cli_command.rb)<a name="tf_cli"/>

The `inspec terraform` CLI command and options. Given this is a Thor CLI, the `desc` and `subcommand_desc` provide help at the CLI. The `class_option`s hash is used to define documentation and settings for allowed subcommand options. Each method (`generate` and `negative`) is turned into further subcommands (ie. `inspec terraform generate`) and there are currently no differences in options between them.

Within the `generate` method the following block:

    generated_controls = InspecPlugins::Iggy::Terraform::Generate.parse_generate(options[:tfstate], resource_path, platform)

calls into the [Terraform generate_parse_generate](#tf_generate) which returns the InSpec controls found by mapping Terraform resources to InSpec resources given a platform and the path to its resources.

    printable_controls = InspecPlugins::Iggy::InspecHelper.tf_controls(options[:title], generated_controls, platform)

calls into the [inspec helper](#inspec_helper) to produce the InSpec controls to include within the profile, filtering on the platform.

    InspecPlugins::Iggy::ProfileHelper.render_profile(ui, options, options[:tfstate], printable_controls, platform)

calls into the [profile renderer](#profile_helper).

The `inspec terraform negative` command uses the same options as the `generate` command and follows the same pattern of parsing the controls, converting them to a printable format, and printing the output as an InSpec profile.

## [lib/inspec-iggy/terraform/generate.rb](lib/inspec-iggy/terraform/generate.rb)<a name="tf_generate"/>

This class parses the passed Terraform .tfstate files. The `parse_generate` method is the standard interface for parsing, it calls into the private `InspecPlugins::Iggy::FileHelper.parse_json` method which reads the actual JSON.

The `parse_resources` method then parses the Terraform JSON, iterating over the `modules` array of `resources` which are then mapped to the appropriate InSpec Resources. The `parse_resources` method calls into the [`InSpecHelper`](#inspec_helper) to `load_resource_pack` to load the additional InSpec Resources provided by the respective platform's resource pack. The [TRANSLATED_RESOURCES](#inspec_helper) provide a mapping of Terraform resources that do not match the InSpec equivalent. The resources that map from Terraform to InSpec are returned.

The parsed resources are then passed to `parse_controls` which generates InSpec Controls and tests for the matched resources. The generated InSpec controls are returned.

## [lib/inspec-iggy/terraform/negative.rb](lib/inspec-iggy/terraform/negative.rb)<a name="tf_negative"/>

The `Negative` class reuses the `InspecPlugins::Iggy::FileHelper.parse_json` and `InspecPlugins::Iggy::Terraform::Generate.parse_resources` to parse the JSON and find the matched resources respectively.

Negative controls are generated by finding the platform resources that are not represented by Terraform (`parse_unmatched_resources`) and those that are managed with Terraform (`parse_matched_resources`).

* `parse_unmatched_resources` iterates over all of the of `InspecPlugins::Iggy::InspecHelper.available_resource_iterators` that are not present in the matched resources. It then creates Controls that test that they `should_not exist` since they are not managed by Terraform.
* `parse_matched_resources` iterates over each matched resource and removes them from the entire set of that resource. If there are any remaining resources they are not managed by Terraform, so we test that they `should_not exist`. Because we are embedding iterators in our Control, we have to render this control by hand rather than use InSpec's Control object.

# CloudFormation<a name="cfn"/>

## [lib/inspec-iggy/cloudformation/cli_command.rb](lib/inspec-iggy/cloudformation/cli_command.rb)<a name="cfn_cli"/>

The CFN `cli_command.rb` is similar to the [terraform/cli_command.rb](#tf_cli). It requires a `:stack` as an option, because it will dynamically generate the InSpec profile from the launched CloudFormation stack in conjunction with the template.

## [lib/inspec-iggy/cloudformation/generate.rb](lib/inspec-iggy/cloudformation/generate.rb)<a name="cfn_generate"/>

The CFN parser is very similar to the [terraform/generate.rb](#tf_generate), parsing a JSON template file and iterating over the 'Resources'.

# Platform Support

## Terraform

For InSpec-Iggy to work, you must have both Terraform and InSpec support for your platform. This is because it maps Terraform resources to InSpec resources. You will need to provide the path to the proper InSpec resource pack providing your platform's resources. If there's not an InSpec plugin for the platform, there won't be any resources generated.

If you have working InSpec and Terraform support, you will want to run with

    inspec terraform generate -t terraform.tfstate --platform PLATFORM --resourcepath ~/ws/inspec-PLATFORM --name DEBUG --debug

and look through the debugging messages to see what is being `SKIPPED`, `TRANSLATED` or `MATCHED`. You may want to drop a `pry` debugging breakpoint within the [Terraform generate](#tf_generate) `parse_resources` method to see what is in the JSON versus what InSpec resources.

If you are not getting `MATCHED` `resource_type` resources and all `SKIPPED`, they are most likely not in the `InspecPlugins::Iggy::InspecHelper::RESOURCES`. The `TRANSLATED_RESOURCES` within the [inspec_helper.rb](#inspec_helper) may need to be updated to map `resource_type`s to what is in InSpec.

At this point there are not mappings for InSpec properties to Terraform attributes. If this is an issue you may need to update the hash of resources and the attribute mappings in the [inspec_helper.rb](#inspec_helper).

### New Platforms

AWS, Azure, and GCP are currently supported in the [lib/inspec-iggy/platforms/]<a name="aws_helper"/>. If you wish to add another platform start with those helpers and provide the same constants and methods, assuming you have Terraform and InSpec support.

## Alternate Formats

If you want to add support for another format (ie. ARM templates or something similar), follow the examples of the [Terraform](#tf) and [CloudFormation](#cfn) support. You will start by adding a new `cli_command` to the [lib/inspec-iggy/plugin.rb](#plugin). You will need a `cli_command.rb` and `parser.rb` implementing the appropriate classes and methods.
