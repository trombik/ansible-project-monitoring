# frozen_string_literal: true

require_relative "../spec_helper"

ruby_version = Specinfra.backend.run_command("ruby -e 'puts RUBY_VERSION'").stdout.strip
ruby_version_major_minor = format("%<major>d.%<minor>d", major: ruby_version.split(".")[0], minor: ruby_version.split(".")[1])

describe file "/home/sensu/.gem" do
  it { should exist }
  it { should be_directory }
end

describe command "/home/sensu/.gem/ruby/#{ruby_version_major_minor}/bin/check-disk-usage.rb" do
  let(:sudo_options) { "-u sensu --set-home" }
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout) { should match(/^CheckDisk/) }
end
