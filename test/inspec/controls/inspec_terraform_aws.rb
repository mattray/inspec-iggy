tmp_dir = input("tmp_dir")
resource_dir = input("resource_dir")

control "inspec terraform generate --name AWS-terraform-two-tier" do
  describe directory tmp_dir do
    it { should exist }
  end

  describe directory resource_dir do
      it { should exist }
  end

  describe command("bundle exec inspec terraform generate --name #{tmp_dir}/AWS-terraform-two-tier -t test/fixtures/terraform/tfstates/aws-terraform-two-tier-example.tfstate --platform aws --resourcepath #{resource_dir}") do
    its('exit_status') { should cmp 0 }
    its("stdout") { should match (/InSpec Iggy Code Generator/) } # skip the non ASCII characters
    its("stdout") { should match (/Creating new profile at/) }
    its("stdout") { should match (/Creating file/) }
    its("stdout") { should match (/Creating directory/) }
  end
end
