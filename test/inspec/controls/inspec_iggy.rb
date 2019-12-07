control "inspec iggy" do
  describe command("bundle exec inspec iggy") do
    its("stdout") { should match (/inspec iggy help \[COMMAND\]/) }
    its("stdout") { should match (/inspec iggy version/) }
  end
end

control "inspec iggy version" do
  describe command("bundle exec inspec iggy version") do
    its("stdout") { should match (/Iggy v0.7.0/) }
  end
end
