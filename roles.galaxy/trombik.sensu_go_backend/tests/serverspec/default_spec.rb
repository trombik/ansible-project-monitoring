require "spec_helper"
require "serverspec"

package = nil
service = "sensu-backend"
config  = "/etc/sensu/backend.yml"
user    = "sensu"
group   = "sensu"
ports   = [3000, 8080]
log_dir = "/var/log/sensu"
db_dir  = "/var/lib/sensu/sensu-backend"
cache_dir = "/var/cache/sensu/sensu-backend"
state_dir = "/var/lib/sensu/sensu-backend"
admin_user = "admin"
admin_password = "P@ssw0rd!"
default_group = "root"
extra_packages = []

case os[:family]
when "redhat"
  package = "sensu-go-backend"
  extra_packages = ["sensu-go-cli"]
when "ubuntu"
  package = "sensu-go-backend"
  extra_packages = ["sensu-go-cli"]
when "freebsd"
  package = "sysutils/sensu-go-backend"
  config = "/usr/local/etc/sensu-backend.yml"
  db_dir = "/var/db/sensu/sensu-backend"
  state_dir = "/var/db/sensu/sensu-backend"
  default_group = "wheel"
  extra_packages = ["sysutils/sensu-go-cli"]
end

describe package(package) do
  it { should be_installed }
end

extra_packages.each do |p|
  describe package p do
    it { should be_installed }
  end
end

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape("# Managed by ansible") }
  its(:content_as_yaml) { should include("state-dir" => state_dir) }
  its(:content_as_yaml) { should include("cache-dir" => cache_dir) }
end

describe file(log_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(db_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(cache_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/sensu_backend") do
    it { should exist }
    it { should be_file }
    it { should be_owned_by "root" }
    it { should be_grouped_into default_group }
    it { should be_mode 644 }
    its(:content) { should match(/Managed by ansible/) }
  end
when "redhat"
  describe file("/etc/sysconfig/sensu-backend") do
    it { should exist }
    it { should be_file }
    it { should be_owned_by "root" }
    it { should be_grouped_into default_group }
    it { should be_mode 644 }
    its(:content) { should match(/Managed by ansible/) }
  end
when "ubuntu"
  describe file("/etc/default/sensu-backend") do
    it { should exist }
    it { should be_file }
    it { should be_owned_by "root" }
    it { should be_grouped_into default_group }
    it { should be_mode 644 }
    its(:content) { should match(/Managed by ansible/) }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

describe command("sensuctl configure -n --url http://127.0.0.1:8080 --username #{Shellwords.escape(admin_user)} --password #{Shellwords.escape(admin_password)} --format yaml") do
  before(:all) do
    Specinfra.backend.run_command("rm -rf /root/.config/sensu")
  end
  its(:exit_status) { should eq 0 }
  case os[:family]
  when "freebsd"
    its(:stderr) { should match(/Using Basic Auth in HTTP mode is not secure/) }
  else
    its(:stderr) { should eq "" }
  end

  its(:stdout) { should eq "" }
end

describe command "sensuctl namespace list --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include(include("name" => "default")) }
  its(:stdout_as_json) { should include(include("name" => "server")) }
end

describe command "sensuctl role list --namespace server --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include(include("metadata" => include("name" => "readonly"))) }
  its(:stdout_as_json) { should include(include("metadata" => include("namespace" => "server"))) }
end

describe command "sensuctl user list --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include(include("username" => "readonly-user")) }
end

describe command "sensuctl role-binding list --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include(include("metadata" => include("name" => "readonly"))) }
  its(:stdout_as_json) { should include(include("role_ref" => include("name" => "readonly"))) }
  its(:stdout_as_json) { should include(include("subjects" => include(include("name" => "readonly-user")))) }
end

describe command "sensuctl asset list --namespace server --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include(include("metadata" => include("name" => "sensu-go-uptime-check"))) }
end

describe command "sensuctl check list --namespace server --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include(include("command" => "sensu-go-uptime-check -w 72h -c 168h")) }
end

describe command "sensuctl entity list --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include(include("entity_class" => "agent")) }
  its(:stdout_as_json) { should include(include("system" => include("platform" => os[:family] == "redhat" ? "centos" : os[:family]))) }
  its(:stdout_as_json) { should include(include("subscriptions" => include("system"))) }
end

describe command "sensuctl asset info --namespace server asachs01/sensu-go-uptime-check --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include("metadata" => include("name" => "asachs01/sensu-go-uptime-check")) }
end

describe command "sensuctl handler list --namespace server --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include(include("metadata" => include("name" => "dev-null"))) }
end

describe command "sensuctl handler list --namespace server --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include(include("metadata" => include("name" => "tcp_handler"))) }
end

describe command "sensuctl tessen info --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include("opt_out" => true) }
end

describe command "sensuctl hook list --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include(include("metadata" => include("name" => "reboot"))) }
end

describe command "sensuctl filter list --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include(include("metadata" => include("name" => "ignore_devel_environment"))) }
end

describe command "sensuctl entity list --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include(include("metadata" => include("name" => "sensu-docs"))) }
end
