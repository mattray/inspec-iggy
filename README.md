# Description #

[![Build Status Master](https://travis-ci.org/inspec/inspec-iggy.svg?branch=master)](https://travis-ci.org/inspec/inspec-iggy)

InSpec-Iggy (InSpec Generate -> "IG" -> "Iggy") is an [InSpec](https://inspec.io) plugin for generating compliance controls and profiles from [Terraform](https://terraform.io) `tfstate` files and [AWS CloudFormation](https://aws.amazon.com/cloudformation/) templates. Iggy generates InSpec controls by mapping Terraform and CloudFormation resources to InSpec resources and exports a profile that may be used from the `inspec` CLI or uploaded to [Chef Automate](https://automate.chef.io/).

    inspec terraform generate -n myprofile
    inspec exec myprofile -t aws://us-west-2
    inspec compliance upload myprofile

Iggy was originally a stand-alone CLI inspired by Christoph Hartmann's [inspec-verify-provision](https://github.com/chris-rock/inspec-verify-provision) and the blog post on testing [InSpec for provisioning testing: Verify Terraform setups with InSpec](http://lollyrock.com/articles/inspec-terraform/).

The [CHANGELOG.md](https://github.com/inspec/iggy/blob/master/CHANGELOG.md) covers current, previous and future development milestones and contains the features backlog.

1. [Requirements](#requirements)
2. [Installation](#installation)
3. [InSpec Terraform Generate](#itg)
4. [InSpec Terraform Extract](#ite)
5. [InSpec Cloudformation Generate](#icg)
6. [Testing](#testing)

# Requirements <a name="requirements"></a>

Iggy generates compliance profiles for InSpec 2.3 and later, which includes the AWS and Azure resources. Because resources are continuing to be added to InSpec, you may want the latest version to support as many resource coverage as possible. It has currently been tested primarily with AWS but other InSpec-supported platforms should work as well.

Written and tested with Ruby 2.5.1.

# Installation <a name="installation"></a>

`inspec-iggy` is a plugin for InSpec.  InSpec 2.3 or later is required.  To install, use:

```
$ inspec plugin install inspec-iggy
```

# InSpec Terraform Generate<a name="itg"></a>

     inspec terraform generate --tfstate terraform.tfstate --name myprofile

Iggy dynamically pulls the available AWS resources from InSpec and attempts to map them to Terraform resources, producing an InSpec profile. ```inspec terraform generate --help``` will show all available options.

## Usage

    inspec terraform generate [options] -n, --name=NAME

     -n, --name=NAME                  Name of profile to be generated (required)
     -t, [--tfstate=TFSTATE]          Specify path to the input terraform.tfstate (default: .)
     [--debug], [--no-debug]          Verbose debugging messages
     [--copyright=COPYRIGHT]          Name of the copyright holder (default: The Authors)
     [--email=EMAIL]                  Email address of the author (default: you@example.com)
     [--license=LICENSE]              License for the profile (default: Apache-2.0)
     [--maintainer=MAINTAINER]        Name of the copyright holder (default: The Authors)
     [--summary=SUMMARY]              One line summary for the profile (default: An InSpec Compliance Profile)
     [--title=TITLE]                  Human-readable name for the profile (default: InSpec Profile)
     [--version=VERSION]              Specify the profile version (default: 0.1.0)
     [--overwrite], [--no-overwrite]  Overwrites existing profile directory

# InSpec Terraform Extract (EXPERIMENTAL)<a name="ite"></a>

    inspec terraform extract --tfstate terraform.tfstate

## Tagging Profiles for Extract ##

Compliance profiles are added to the Terraform Resource to be tested. The current 2 options are the ```aws_vpc``` or the ```aws_instance```. By tagging the ```aws_vpc``` you are specifying that the test is against the AWS API rather than individual machines. AWS instances tagged with compliance profiles will attempt to form command lines for ```inspec exec``` against them.

### Tagging Format ###

Given there is not support for lists within AWS tags, we use the convention of starting our tag names with ```inspec_name_``` and ```inspec_url_```. These are extracted and split to identify the relevant compliance profiles to run.

```
tags {
    iggy_name_apache_baseline = "apache-baseline",
    iggy_url_apache_baseline = "https://github.com/dev-sec/apache-baseline",
    iggy_name_linux_baseline = "linux-baseline",
    iggy_url_linux_baseline = "https://github.com/dev-sec/linux-baseline"
}
```

### Potential Enhancements ###

The current tagging for extraction implementation is directly tied to AWS. Other platforms such as Azure undoubtedly behave differently. Longterm this functionality should probably be turned into a Terraform Provider with predefined outputs.

Subnet might be a better choice for tagging than VPCs, given they list the AZ.

Currently it only supports URL-based compliance profiles. InSpec supports other formats (git, path, supermarket, compliance).

inspec exec https://github.com/dev-sec/linux-baseline -t ssh://clckwrk@52.33.203.34 -i ~/.ssh/mattray-apac

# InSpec CloudFormation Generate<a name="icg"></a>

    inspec cloudformation generate --template mytemplate.json --stack mystack-20180909T052147Z --profile myprofile

Iggy supports AWS CloudFormation templates by mapping the AWS resources to InSpec resources and using the stack name or unique stack ID associated with the CloudFormation template as an entry point to check those resources in the generated profile. ```inspec cloudformation generate --help``` will show all available options.

## Usage

     inspec cloudformation generate [options] -n, --name=NAME -s, --stack=STACK -t, --template=TEMPLATE

     -n, --name=NAME                  Name of profile to be generated (required)
     -s, --stack=STACK                Specify stack name or unique stack ID associated with the CloudFormation template
     -t, --template=TEMPLATE          Specify path to the input CloudFormation template
     [--debug], [--no-debug]          Verbose debugging messages
     [--copyright=COPYRIGHT]          Name of the copyright holder (default: The Authors)
     [--email=EMAIL]                  Email address of the author (default: you@example.com)
     [--license=LICENSE]              License for the profile (default: Apache-2.0)
     [--maintainer=MAINTAINER]        Name of the copyright holder (default: The Authors)
     [--summary=SUMMARY]              One line summary for the profile (default: An InSpec Compliance Profile)
     [--title=TITLE]                  Human-readable name for the profile (default: InSpec Profile)
     [--version=VERSION]              Specify the profile version (default: 0.1.0)
     [--overwrite], [--no-overwrite]  Overwrites existing profile directory

# Development

## Installation

To point `inspec` at a local copy of `inspec-iggy` for development, use:

```
$ inspec plugin install path/to/your/inspec-iggy/lib/inspec-iggy.rb
```

# Testing Iggy<a name="testing"></a>


Unit, Functional, and Integration tests are provided, though more are welcome. Iggy uses the RSpec library for testing, using the `expect('subject').to matcher` syntax.

To run all tests, run

```
$ bundle exec rake test
```

Linting is also provided via Rubocop.

To check for code style issues, run:

```
$ bundle exec rake lint
```

You can auto-correct many issues:

```
$ bundle exec rubocop -a
```

# License and Author #

|                |                                           |
|:---------------|:------------------------------------------|
| **Author**     | Matt Ray (<matt@chef.io>)                 |
| **Copyright:** | Copyright (c) 2017-2018 Chef Software Inc.|
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
