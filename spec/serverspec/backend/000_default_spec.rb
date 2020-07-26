# frozen_string_literal: true

require_relative "../spec_helper"

describe "mon.i.trombik.org" do
  it_behaves_like "a host with all basic tools installed"
end

describe command "date +%z" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout) { should match(/^\+0700$/) }
end

describe user "trombik" do
  it { should exist }
  it { should belong_to_primary_group "wheel" }
  it { should belong_to_group "dialer" }
  it { should have_login_shell "/usr/local/bin/zsh" }
end

describe file "/home/trombik/.ssh/authorized_keys" do
  it { should exist }
  its(:content) { should match(/^ssh-rsa /) }
  its(:content) { should match(/y@trombik.org$/) }
end
