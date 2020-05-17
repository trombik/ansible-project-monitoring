require "spec_helper"
require "serverspec"
require "yaml"

package = "ruby"

case os[:family]
when "freebsd"
  package = "lang/ruby24"
when "ubuntu"
  if host_inventory["platform_version"].to_f == 16.04
    package = "ruby2.3"
  elsif host_inventory["platform_version"].to_f == 14.04
    package = "ruby2.0"
  end
end

describe package(package) do
  it { should be_installed }
end

describe command("ruby --version") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^ruby \d+\.\d+\.\d+/) }
  its(:stderr) { should eq("") }
end

describe command("gem --version") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^\d+\.\d+\.\d+/) }
  its(:stderr) { should eq("") }
end
