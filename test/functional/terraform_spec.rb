require "helper"
require "json"

module IggyFunctionalTests
  class Terraform < Minitest::Test
    include CorePluginFunctionalHelper
    include IggyFunctionalHelper

    def tfstate_fixtures_path
      File.join(iggy_fixtures_path, "terraform", "tfstates")
    end

    def test_generate_on_aws_tfstate
      # Iggy can't write a profile anywhere than the current directory;
      # and run_inspec_process_with_this_plugin does not actually chdir to the tempdir.
      # So, we're writing this profile in the project root.
      # This will result in collisions under CI.
      iggy_command  = "terraform "
      iggy_command += " generate "
      iggy_command += " --overwrite "
      iggy_command += " --name iggy-test-profile "
      iggy_command += " --tfstate " + File.join(tfstate_fixtures_path, "aws-terraform.tfstate")

      iggy_run_result = run_inspec_process_with_this_plugin(iggy_command, post_run: run_check_and_json)

      assert_empty(iggy_run_result.stderr)
      assert_equal(0, iggy_run_result.exit_status)
      assert_includes(iggy_run_result.stdout, "Create new profile")
      # TODO: more UX messaging tests

      check_result = iggy_run_result.payload.check_result
      assert_equal(0, check_result.exit_status)

      check_json = iggy_run_result.payload.check_json
      assert(check_json["summary"]["valid"])
      assert_empty(check_json["errors"])
      assert_empty(check_json["warnings"])
      assert_equal(6, check_json["summary"]["controls"])

      # TODO: many many tests could be done here
      export_json = iggy_run_result.payload.export_json

      # TODO: have iggy mark the profile with the required platform
      # assert_includes(export_json['supports'], 'aws')

      # Here is one spot-check
      an_instance = export_json["controls"].detect { |c| c["title"].include?("0775ff99e9bce8ecd") }
      refute_nil an_instance
      instance_codelines = an_instance["code"].split("\n")
      resource_line = instance_codelines.detect { |l| l.include? "describe aws_ec2_instance" }
      refute_nil resource_line
    end

    # TODO: DRY this up, obviously
    def test_generate_on_azure_tfstate
      # Iggy can't write a profile anywhere than the current directory;
      # and run_inspec_process_with_this_plugin does not actually chdir to the tempdir.
      # So, we're writing this profile in the project root.
      # This will result in collisions under CI.
      iggy_command  = "terraform "
      iggy_command += " generate "
      iggy_command += " --overwrite "
      iggy_command += " --name iggy-test-profile "
      iggy_command += " --tfstate " + File.join(tfstate_fixtures_path, "azure-terraform.tfstate")

      iggy_run_result = run_inspec_process_with_this_plugin(iggy_command, post_run: run_check_and_json)

      assert_empty(iggy_run_result.stderr)
      assert_equal(0, iggy_run_result.exit_status)
      assert_includes(iggy_run_result.stdout, "Create new profile")
      # TODO: more UX messaging tests

      check_result = iggy_run_result.payload.check_result
      assert_equal(0, check_result.exit_status)

      check_json = iggy_run_result.payload.check_json
      assert(check_json["summary"]["valid"])
      assert_empty(check_json["errors"])

      # Iggy currently generates an empty profile

      # assert_empty(check_json['warnings'])
      # assert_equal(0, check_json['summary']['controls'])

      # TODO: many many tests could be done here
      # export_json = iggy_run_result.payload.export_json

      # TODO: have iggy mark the profile with the required platform
      # assert_includes(export_json['supports'], 'azure')
    end
  end

  # TODO: add tests that demo iggy's error handling
end
