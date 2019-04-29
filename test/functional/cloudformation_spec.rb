require 'helper'
require 'json'

module IggyFunctionalTests
  class CloudFormtation < Minitest::Test
    include CorePluginFunctionalHelper
    include IggyFunctionalHelper

    def cfn_fixtures_path
      File.join(iggy_fixtures_path, 'cloudformation')
    end

    def test_generate_on_aws_tfstate

      # Iggy can't write a profile anywhere than the current directory;
      # and run_inspec_process_with_this_plugin does not actually chdir to the tempdir.
      # So, we're writing this profile in the project root.
      # This will result in collisions under CI.
      iggy_command  = 'cloudformation '
      iggy_command += ' generate '
      iggy_command += ' --overwrite '
      iggy_command += ' --name iggy-test-profile '
      iggy_command += ' --template ' + File.join(cfn_fixtures_path, 'aws-4.5.4.json')
      iggy_command += ' --stack Application '

      iggy_run_result = run_inspec_process_with_this_plugin(iggy_command, post_run: run_check_and_json)

      assert_empty(iggy_run_result.stderr)
      assert_equal(0, iggy_run_result.exit_status)
      assert_includes(iggy_run_result.stdout, 'Create new profile')
      # TODO: more UX messaging tests

      check_result = iggy_run_result.payload.check_result
      assert_equal(0, check_result.exit_status)

      check_json = iggy_run_result.payload.check_json
      assert(check_json['summary']['valid'])
      assert_empty(check_json['errors'])
      assert_empty(check_json['warnings'])
      assert_equal(16, check_json['summary']['controls'])

      # TODO: many many tests could be done here
      export_json = iggy_run_result.payload.export_json

      # TODO: have iggy mark the profile with the required platform
      # assert_includes(export_json['supports'], 'aws')

      # Here is one spot-check
      an_instance = export_json['controls'].detect { |c| c['title'].include?('union') }
      refute_nil an_instance
      instance_codelines = an_instance['code'].split("\n")
      resource_line = instance_codelines.detect { |l| l.include? 'describe aws_ec2_instance'}
      refute_nil resource_line

    end
    # TODO: tests on other "versions"?
  end
  # TODO: tests that cover error conditions gracefully
end
