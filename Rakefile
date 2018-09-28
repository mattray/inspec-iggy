#------------------------------------------------------------------#
#                    Gem Packaging Tasks
#------------------------------------------------------------------#
begin
  require "bundler"
  Bundler::GemHelper.install_tasks
rescue LoadError
  # no bundler available
end

#------------------------------------------------------------------#
#                    Test Runner Tasks
#------------------------------------------------------------------#

namespace(:test) do
  begin
    # This task template will make a task named 'test', and run
    # the tests that it finds.
    # Here, we split up the tests a bit, for the convenience
    # of the developer.
    require 'rspec/core/rake_task'
    desc 'Run unit tests, to probe internal correctness'
    RSpec::Core::RakeTask.new(:unit) do |task|
      task.pattern = 'test/unit/*_spec.rb'
    end

    desc 'Run functional tests, to verify user experience'
    RSpec::Core::RakeTask.new(:functional) do |task|
      task.pattern = 'test/functional/*_spec.rb'
    end

    desc 'Run legacy tests'
    RSpec::Core::RakeTask.new(:legacy) do |task|
      task.pattern = 'spec/*_spec.rb'
    end

    RSpec::Core::RakeTask.new(:all) do |task|
      task.pattern = [
        'test/unit/*_spec.rb',
        'test/functional/*_spec.rb',
        'spec/*_spec.rb',
      ]
    end

  rescue LoadError
    # no rspec available
  end
end

# Define a 'run all the tests' task.
# You might think you'd want to depend on test:unit and test:functional,
# but if you do that and either has a failure, th latter won't execute.
desc 'Run all tests.'
task :test => [:'test:all']