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
#                    Linter Tasks
#------------------------------------------------------------------#

begin
  require "chefstyle"
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new(:lint) do |task|
    task.options += ["--display-cop-names", "--no-color", "--parallel"]
  end

rescue LoadError
  puts 'rubocop is not available. Install the rubocop gem to run the lint tests.'
end

#------------------------------------------------------------------#
#                    Test Runner Tasks
#------------------------------------------------------------------#
require 'rake/testtask'

namespace(:test) do
  # This task template will make a task named 'test', and run
  # the tests that it finds.
  # Here, we split up the tests a bit, for the convenience
  # of the developer.
  desc 'Run unit tests, to probe internal correctness'
  Rake::TestTask.new(:unit) do |task|
    task.libs << 'test'
    task.pattern = 'test/unit/*_spec.rb'
    task.warning = false
  end

  desc 'Run functional tests, to verify user experience'
  Rake::TestTask.new(:functional) do |task|
    task.libs << 'test'
    #    task.pattern = 'test/functional/*_spec.rb'
    task.warning = false
  end

  desc 'Run integration tests for check for interface changes'
  Rake::TestTask.new(:integration) do |task|
    task.libs << 'test'
    #    task.pattern = 'test/integration/*_spec.rb'
    task.warning = false
  end

  desc 'Run all tests, and keep going if one set fails.'
  Rake::TestTask.new(:keep_going) do |task|
    task.libs << 'test'
    task.pattern = [
      'test/unit/*_spec.rb',
      #     'test/functional/*_spec.rb',
      #     'test/integration/*_spec.rb',
    ]
    task.warning = false
    #task.verbose = true
  end
end

# Define a 'run all the tests' task.
# You might think you'd want to depend on test:unit and test:functional,
# but if you do that and either has a failure, the latter won't execute.
desc 'Run all tests'
task :test => [:'test:unit', :'test:functional', :'test:integration']
