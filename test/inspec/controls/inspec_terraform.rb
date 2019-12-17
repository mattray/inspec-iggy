# tmp_dir = input("tmp_dir", value: "FOO")

control "inspec terraform" do
  describe command("bundle exec inspec terraform") do
    its("stdout") { should match(/inspec terraform generate \[options\]/) }
    its("stdout") { should match(/inspec terraform help \[COMMAND\]/) }
    its("stdout") { should match(/inspec terraform negative \[options\]/) }
    its("stdout") { should match(/\[--log-level=LOG_LEVEL\]/) }
    its("stdout") { should match(/\[--log-location=LOG_LOCATION\]/) }
    its("stdout") { should match(/\[--debug\], \[--no-debug\]/) }
    its("stdout") { should match(/\[--copyright=COPYRIGHT\]/) }
    its("stdout") { should match(/\[--email=EMAIL\]/) }
    its("stdout") { should match(/\[--license=LICENSE\]/) }
    its("stdout") { should match(/\[--maintainer=MAINTAINER\]/) }
    its("stdout") { should match(/\[--summary=SUMMARY\]/) }
    its("stdout") { should match(/\[--title=TITLE\]/) }
    its("stdout") { should match(/\[--version=VERSION\]/) }
    its("stdout") { should match(/\[--overwrite\], \[--no-overwrite\]/) }
    its("stdout") { should match(/-n, --name=NAME/) }
    its("stdout") { should match(/-t, \[--tfstate=TFSTATE\]/) }
    its("stdout") { should match(/\--platform=PLATFORM/) }
    its("stdout") { should match(/\--resourcepath=RESOURCEPATH/) }
  end
end

control "inspec terraform -t" do
  # describe command("bundle exec inspec terraform #{tmp_dir}/terraform") do
  #   its('stdout') { should match (/inspec terraform negative \[options\]/) }
  # end
end
