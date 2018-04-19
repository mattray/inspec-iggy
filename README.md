# Description #

Iggy is a command-line tool for generating [InSpec](https://inspec.io) compliance profiles from [Terraform](https://terraform.io) scripts. You may use tags to annotate your Terraform scripts to specify which compliance profiles will be used and iggy will create a profile including those dependencies. Iggy will also attempt to generate InSpec AWS audits by mappping Terraform resources to InSpec resources.

The [CHANGELOG.md](https://github.com/mattray/iggy/blob/master/CHANGELOG.md) covers current, previous and future development milestones and contains the features backlog.

Iggy was inspired by Christoph Hartmann's [inspec-verify-provision](https://github.com/chris-rock/inspec-verify-provision) and the blog post on testing [Terraform with InSpec](http://lollyrock.com/articles/inspec-terraform/)

# Requirements #

Iggy generates compliance profiles for InSpec 2, which includes the AWS resources. Because AWS resources are continuing to be added to InSpec, you may need the latest version to support as many resources as possible.

Written and tested with Ruby 2.4.3 (or whatever InSpec 2.0 supports).

# Building #

## Bundler ##

    mkdir  .bundle
    bundle install --path=.bundle
    bundle exec bin/iggy

## Gem install ##

Once it's published to Rubygems

    gem install iggy

# Usage #

iggy terraform.tfstate

## Tagging Profiles ##

If you are using AWS

## InSpec AWS Resources ##

Iggy dynamically pulls the available AWS resources from InSpec and attempts to map them to the Terraform resources. Newer versions of InSpec may provide additional coverage.

# OPTIONS #

## -p/--profile ##

Name of the profile to generate. Defaults to `iggy` if none is given.

## --debug ##

This provides verbose debugging messages.

## -h/--help ##

Print the currently-supported usage options for iggy.

## -v/--version ##

Print the version of iggy currently installed.

# Testing #

Iggy uses [RSpec](http://rspec.info/) for testing. You should run the following before committing.

    $ rspec test

# License and Author #

|                      |                                                    |
|:---------------------|:---------------------------------------------------|
| **Author**           |  Matt Ray (<matt@chef.io>)                         |
|                      |                                                    |
| **Copyright**        |  Copyright (c) 2018, Chef Software, Inc.           |

All rights reserved.
