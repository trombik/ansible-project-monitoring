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
gems = %w[sensu-handlers-elasticsearch]
case os[:family]
when "redhat"
  package = "sensu-go-backend"
  extra_packages = ["sensu-go-cli"]
when "ubuntu"
  package = "sensu-go-backend"
  extra_packages = ["sensu-go-cli"]
when "freebsd"
  package = "sysutils/sensu-go-backend"
  config = "/usr/local/etc/sensu/backend.yml"
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

# rubocop:disable Style/GlobalVars
describe command("sensuctl configure -n --url #{$BACKEND_URL} --username #{Shellwords.escape(admin_user)} --password #{Shellwords.escape(admin_password)} --trusted-ca-file #{Shellwords.escape($CA_CERT)} --format yaml") do
  # rubocop:enable Style/GlobalVars
  before(:all) do
    Specinfra.backend.run_command("rm -rf /root/.config/sensu")
  end
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
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
  its(:stdout_as_json) { should include(include("metadata" => include("name" => "tcp_handler"))) }
  its(:stdout_as_json) { should include(include("metadata" => include("name" => "keepalive"))) }
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

describe command "sensuctl cluster-role list --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include(include("metadata" => include("name" => "readonly-cluster"))) }
end

describe command "sensuctl cluster-role-binding list --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include(include("metadata" => include("name" => "cluster-wide-readonly"))) }
end

describe command "sensuctl mutator list --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include(include("metadata" => include("name" => "cat"))) }
end

gems.each do |g|
  case os[:family]
  when "redhat"
    describe command "/opt/sensu-plugins-ruby/embedded/bin/gem list --local" do
      its(:stderr) { should eq "" }
      its(:stdout) { should match(/#{g}/) }
    end
  else
    describe package g do
      let(:sudo_options) { "-u #{user} --set-home" }
      it { should be_installed.by("gem") }
    end
  end
end

conf_dir = case os[:family]
           when "freebsd"
             "/usr/local/etc/sensu/conf.d"
           else
             "/etc/sensu/conf.d"
           end
describe file conf_dir do
  it { should exist }
  it { should be_directory }
  it { should be_mode 755 }
  it { should be_owned_by "root" }
  it { should be_grouped_into default_group }
end

fragments = %w[foo.json bar.json]
fragments.each do |f|
  describe file "#{conf_dir}/#{f}" do
    it { should exist }
    it { should be_file }
    it { should be_owned_by "root" }
    it { should be_grouped_into default_group }
    its(:content_as_json) { should include("example" => include("name" => f.split(".").first.to_s)) }
  end
end

describe file "#{conf_dir}/template_file.erb" do
  it { should exist }
  it { should be_file }
  it { should be_owned_by "root" }
  it { should be_grouped_into default_group }
  its(:content) { should match(/foo/) }
end
