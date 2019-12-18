# Description #

[![Build Status Master](https://travis-ci.org/mattray/inspec-iggy.svg?branch=master)](https://travis-ci.org/mattray/inspec-iggy)

InSpec-Iggy (InSpec Generate -> "IG" -> "Iggy") is an [InSpec](https://inspec.io) plugin for generating compliance controls and profiles from [Terraform](https://terraform.io) `tfstate` files and [AWS CloudFormation](https://aws.amazon.com/cloudformation/) templates. Iggy generates InSpec controls by mapping Terraform and CloudFormation resources to InSpec resources and exports a profile that may be used from the `inspec` CLI and report to [Chef Automate](https://automate.chef.io/).

    inspec terraform generate -n myprofile --platform aws --resourcepath /tmp/inspec-aws
    inspec exec myprofile -t aws://us-west-2

Iggy was originally a stand-alone CLI inspired by Christoph Hartmann's [inspec-verify-provision](https://github.com/chris-rock/inspec-verify-provision) and the blog post on testing [InSpec for provisioning testing: Verify Terraform setups with InSpec](http://lollyrock.com/articles/inspec-terraform/).

The [CHANGELOG.md](https://github.com/mattray/iggy/blob/master/CHANGELOG.md) covers current, previous and future development milestones and contains the features backlog.

1. [Requirements](#requirements)
2. [Support](#support)
3. [Installation](#installation)
4. [InSpec Terraform Generate](#itg)
5. [InSpec Terraform Negative](#itn)
6. [InSpec Cloudformation Generate](#icg)
7. [Development and Testing](#development)

# Support<a name="support"></a>

InSpec-Iggy is a community-driven plugin that is not officially supported by Chef. We welcome patches, suggestions, and issues.

# Requirements <a name="requirements"></a>

Iggy generates compliance profiles for InSpec 3 and later, requiring external resource packs for the AWS, Azure, and GCP resources. Because resources are continuing to be added to InSpec, you may want the latest version to support as much resource coverage as possible.

Written and tested with Ruby 2.6 and InSpec 4.

# Installation <a name="installation"></a>

`inspec-iggy` is a plugin for InSpec.  InSpec 3 or later is required.  To install, use:

    $ inspec plugin install inspec-iggy

You will need to download the [inspec-aws](https://github.com/inspec/inspec-aws)|[inspec-azure](https://github.com/inspec/inspec-azure)|[inspec-gcp](https://github.com/inspec/inspec-gcp) resources packs as necessary and place them in your path for loading via `--resourcepath`.

# InSpec Terraform Generate<a name="itg"></a>

    inspec terraform generate --tfstate terraform.tfstate --name myprofile --platform aws --resourcepath /tmp/inspec-aws

Iggy dynamically pulls the available Cloud resources from InSpec and attempts to map them to Terraform resources, producing an InSpec profile. ```inspec terraform generate --help``` will show all available options.

## Usage

    inspec terraform generate [options] -n, --name=NAME

     -n, --name=NAME                  Name of profile to be generated (required)
     -t, [--tfstate=TFSTATE]          Specify path to the input terraform.tfstate (default: .)
     --platform=gcp|aws|azure         Cloud provider name
     --resourcepath=PATH              Location of inspec-gcp|inspec-aws|inspec-azure resources
     [--copyright=COPYRIGHT]          Name of the copyright holder (default: The Authors)
     [--email=EMAIL]                  Email address of the author (default: you@example.com)
     [--license=LICENSE]              License for the profile (default: Apache-2.0)
     [--maintainer=MAINTAINER]        Name of the copyright holder (default: The Authors)
     [--summary=SUMMARY]              One line summary for the profile (default: An InSpec Compliance Profile)
     [--title=TITLE]                  Human-readable name for the profile (default: InSpec Profile)
     [--version=VERSION]              Specify the profile version (default: 0.1.0)
     [--overwrite], [--no-overwrite]  Overwrites existing profile directory
     [--debug], [--no-debug]          Verbose debugging messages
     [--log-level=LOG_LEVEL]          Set the log level: info (default), debug, warn, error
     [--log-location=LOG_LOCATION]    Location to send diagnostic log messages to. (default: STDOUT or Inspec::Log.error)
     Note: --resourcepath should point to the directory where inspec-<cloud_provider> resource pack is downloaded/cloned from GitHub.

# InSpec Terraform Negative<a name="itn"></a>

    inspec terraform negative --tfstate terraform.tfstate --name myprofile --platform aws --resourcepath /tmp/inspec-aws

Iggy dynamically pulls the available Cloud resources from InSpec and attempts to map them to Terraform resources, producing an InSpec profile which are not part of tfstate file. It informs the user that these resources are not part of tfstate file and can be deleted if not needed.```inspec terraform negative --help``` will show all available options.

## Usage

    inspec terraform negative [options] -n, --name=NAME

     -n, --name=NAME                  Name of profile to be generated (required)
     -t, [--tfstate=TFSTATE]          Specify path to the input terraform.tfstate (default: .)
     --platform=gcp|aws|azure         Cloud provider name
     --resourcepath=PATH              Location of inspec-gcp|inspec-aws|inspec-azure resources
     [--copyright=COPYRIGHT]          Name of the copyright holder (default: The Authors)
     [--email=EMAIL]                  Email address of the author (default: you@example.com)
     [--license=LICENSE]              License for the profile (default: Apache-2.0)
     [--maintainer=MAINTAINER]        Name of the copyright holder (default: The Authors)
     [--summary=SUMMARY]              One line summary for the profile (default: An InSpec Compliance Profile)
     [--title=TITLE]                  Human-readable name for the profile (default: InSpec Profile)
     [--version=VERSION]              Specify the profile version (default: 0.1.0)
     [--overwrite], [--no-overwrite]  Overwrites existing profile directory
     [--debug], [--no-debug]          Verbose debugging messages
     [--log-level=LOG_LEVEL]          Set the log level: info (default), debug, warn, error
     [--log-location=LOG_LOCATION]    Location to send diagnostic log messages to. (default: STDOUT or Inspec::Log.error)

     Note: --resourcepath should point to the directory where inspec-<cloud_provider> resource pack is downloaded/cloned from GitHub.

# InSpec CloudFormation Generate<a name="icg"></a>

    inspec cloudformation generate --template mytemplate.json --stack mystack-20180909T052147Z --profile myprofile

Iggy supports AWS CloudFormation templates by mapping the AWS resources to InSpec resources and using the stack name or unique stack ID associated with the CloudFormation template as an entry point to check those resources in the generated profile. ```inspec cloudformation generate --help``` will show all available options.

## Usage

     inspec cloudformation generate [options] -n, --name=NAME -s, --stack=STACK -t, --template=TEMPLATE

     -n, --name=NAME                  Name of profile to be generated (required)
     -s, --stack=STACK                Specify stack name or unique stack ID associated with the CloudFormation template
     -t, --template=TEMPLATE          Specify path to the input CloudFormation template
     [--copyright=COPYRIGHT]          Name of the copyright holder (default: The Authors)
     [--email=EMAIL]                  Email address of the author (default: you@example.com)
     [--license=LICENSE]              License for the profile (default: Apache-2.0)
     [--maintainer=MAINTAINER]        Name of the copyright holder (default: The Authors)
     [--summary=SUMMARY]              One line summary for the profile (default: An InSpec Compliance Profile)
     [--title=TITLE]                  Human-readable name for the profile (default: InSpec Profile)
     [--version=VERSION]              Specify the profile version (default: 0.1.0)
     [--overwrite], [--no-overwrite]  Overwrites existing profile directory
     [--debug], [--no-debug]          Verbose debugging messages
     [--log-level=LOG_LEVEL]          Set the log level: info (default), debug, warn, error
     [--log-location=LOG_LOCATION]    Location to send diagnostic log messages to. (default: STDOUT or Inspec::Log.error)

# InSpec Iggy<a name="ii"></a>

    inspec iggy version

This command exists for checking the Iggy plugin version, primarily for debugging purposes.

# Development and Testing<a name="development"></a>

The [DESIGN.md](DESIGN.md) file outlines how the code is structured if you wish to extend functionality. We welcome patches, suggestions, and issues.

## Installation

To point `inspec` at a local copy of `inspec-iggy` for development, use:

    $ inspec plugin install path/to/your/inspec-iggy/lib/inspec-iggy.rb

## Testing Iggy

Unit, Functional, and Integration tests are provided, though more are welcome. Iggy uses the Minitest library for unit testing, using the classic `def test...` syntax. Because Iggy loads InSpec into memory, and InSpec uses RSpec internally, Spec-style testing breaks. For Integration and regression testing Iggy uses InSpec itself for tests (check the Rakefile and [test/inspec](test/inspec) for examples).

To run all tests, run

    $ bundle exec rake test

Linting is also provided via [Chefstyle](https://github.com/chef/chefstyle).

To check for code style issues, run:

    $ bundle exec rake lint

You can auto-correct many issues:

    $ bundle exec rake lint:auto_correct

# License and Author #

|                |                                           |
|:---------------|:------------------------------------------|
| **Author**     | Matt Ray (<matt@chef.io>)                 |
| **Copyright:** | Copyright (c) 2017-2019 Chef Software Inc.|
| **License:**   | Apache License, Version 2.0               |

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
