# Description #

Iggy is a command-line tool for generating [InSpec](https://inspec.io) compliance validation from [Terraform](https://terraform.io) ```tfstate``` files. You may use tags to annotate your Terraform scripts to specify which compliance profiles will be used and iggy will create a profile including those dependencies. Iggy will also attempt to generate InSpec AWS audits by mappping Terraform resources to InSpec resources.

The [CHANGELOG.md](https://github.com/mattray/iggy/blob/master/CHANGELOG.md) covers current, previous and future development milestones and contains the features backlog.

Iggy was inspired by Christoph Hartmann's [inspec-verify-provision](https://github.com/chris-rock/inspec-verify-provision) and the blog post on testing [Terraform with InSpec](http://lollyrock.com/articles/inspec-terraform/)

# Requirements #

Iggy generates compliance profiles for InSpec 2, which includes the AWS resources. Because AWS resources are continuing to be added to InSpec, you may need the latest version to support as many resources as possible.

Written and tested with Ruby 2.4.4 (or whatever InSpec 2.0 supports).

# Building #

## Bundler ##

    mkdir  .bundle
    bundle install --path=.bundle
    bundle exec bin/iggy

## Gem install ##

Once it's published to Rubygems

    gem install iggy

# Terraform Extract Usage #

    iggy terraform extract --tfstate terraform.tfstate

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

# Terraform Generate Usage #

     iggy terraform generate --tfstate terraform.tfstate

Iggy dynamically pulls the available AWS resources from InSpec and attempts to map them to the Terraform resources. Newer versions of InSpec may provide additional coverage.

# CloudFormation Support #

**CloudFormation support has been started, but it is incomplete while focusing on Terraform.** Here is an example of the current output, note that it's not tied to an actual deployed CloudFormation Stack, so that will need to be provided for the entry point of testing.
https://gist.github.com/c4d6eda82dfb25502ef381cc631a1edd

# Testing #

Iggy uses [RSpec](http://rspec.info/) for testing. You should run the following before committing.

    $ rspec

For style

    $ chefstyle .

# License and Author #

|                      |                                                    |
|:---------------------|:---------------------------------------------------|
| **Author**           |  Matt Ray (<matt@chef.io>)                         |
|                      |                                                    |
| **Copyright**        |  Copyright (c) 2018, Chef Software, Inc.           |

All rights reserved.
