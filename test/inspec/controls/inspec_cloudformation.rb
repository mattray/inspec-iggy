control 'inspec cloudformation' do
  describe command("bundle exec inspec cloudformation") do
    its('stdout') { should match (/inspec cloudformation generate \[options\] -n, --name=NAME -s, --stack=STACK -t, --template=/) }
    its('stdout') { should match (/inspec cloudformation help \[COMMAND\]/) }
    its('stdout') { should match (/\[--log-level=LOG_LEVEL\]/) }
    its('stdout') { should match (/\[--log-location=LOG_LOCATION\]/) }
    # its('stdout') { should match (/\[--debug\], \[--no-debug\]/) }
    # its('stdout') { should match (/\[--copyright=COPYRIGHT\]/) }
    # its('stdout') { should match (/\[--email=EMAIL\]/) }
    # its('stdout') { should match (/\[--license=LICENSE\]/) }
    # its('stdout') { should match (/\[--maintainer=MAINTAINER\]/) }
    # its('stdout') { should match (/\[--summary=SUMMARY\]/) }
    # its('stdout') { should match (/\[--title=TITLE\]/) }
    # its('stdout') { should match (/\[--version=VERSION\]/) }
    # its('stdout') { should match (/\[--overwrite\], \[--no-overwrite\]/) }
    # its('stdout') { should match (/-n, --name=NAME/) }
    # its('stdout') { should match (/-s, \[--stack=STACK\]/) }
    # its('stdout') { should match (/-t, \[--template=TEMPLATE\]/) }
  end
end

control 'inspec cloudformation help generate' do
  describe command("bundle exec inspec cloudformation help generate") do
    its('stdout') { should match (/inspec cloudformation generate \[options\] -n, --name=NAME -s, --stack=STACK -t, --template/) }
    its('stdout') { should match (/\[--debug\], \[--no-debug\]/) }
    its('stdout') { should match (/\[--copyright=COPYRIGHT\]/) }
    its('stdout') { should match (/\[--email=EMAIL\]/) }
    its('stdout') { should match (/\[--license=LICENSE\]/) }
    its('stdout') { should match (/\[--maintainer=MAINTAINER\]/) }
    its('stdout') { should match (/\[--summary=SUMMARY\]/) }
    its('stdout') { should match (/\[--title=TITLE\]/) }
    its('stdout') { should match (/\[--version=VERSION\]/) }
    its('stdout') { should match (/\[--overwrite\], \[--no-overwrite\]/) }
    its('stdout') { should match (/-n, --name=NAME/) }
    its('stdout') { should match (/-s, --stack=STACK/) }
    its('stdout') { should match (/-t, --template=TEMPLATE/) }
    its('stdout') { should match (/\[--log-level=LOG_LEVEL\]/) }
    its('stdout') { should match (/\[--log-location=LOG_LOCATION\]/) }
  end
end
