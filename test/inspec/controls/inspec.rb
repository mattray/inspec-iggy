control 'inspec CLI' do
  describe command("bundle exec inspec") do
    its('stdout') { should match (/inspec iggy/) }
    its('stdout') { should match (/inspec terraform SUBCOMMAND .../) }
    its('stdout') { should match (/inspec cloudformation SUBCOMMAND .../) }
  end
end
