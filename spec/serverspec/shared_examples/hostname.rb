# frozen_string_literal: true

shared_examples "a host with a valid hostname" do
  describe command("hostname") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq "" }
    # XXX some OS allow to set FQDN as hostname, but others do not (Ubuntu)
    its(:stdout) { should match(/^#{ENV["TARGET_HOST"].split(".").first}(?:\.i\.trombik\.org)?$/) }
  end
end
