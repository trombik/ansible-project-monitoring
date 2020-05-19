# frozen_string_literal: true

require_relative "../spec_helper"

admin_user = credentials_yaml["sensu_go_backend_admin_account"]
admin_pass = credentials_yaml["sensu_go_backend_admin_password"]
gems = %w[sensu-plugins-slack]
sensu_user = "sensu"

describe command("sensuctl configure -n --url http://127.0.0.1:8080 --username #{Shellwords.escape(admin_user)} --password #{Shellwords.escape(admin_pass)} --format yaml") do
  before(:all) do
    Specinfra.backend.run_command("rm -rf /root/.config/sensu")
  end
  its(:exit_status) { should eq 0 }
  its(:stdout) { should eq "" }
  its(:stderr) { should eq "" }
end

describe command "sensuctl user list --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include(include("username" => "readonly")) }
end

describe command "sensuctl check list --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include(include("metadata" => include("name" => "check_disk"))) }
end

describe command "sensuctl handler list --format json" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout_as_json) { should include(include("metadata" => include("name" => "slack"))) }
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
      let(:sudo_options) { "-u #{sensu_user} --set-home" }
      it { should be_installed.by("gem") }
    end
  end
end

sensu_plugins_conf_dir = case os[:family]
                         when "freebsd"
                           "/usr/local/etc/sensu/conf.d"
                         else
                           "/etc/sensu/conf.d"
                         end

describe file "#{sensu_plugins_conf_dir}/handler-slack.json" do
  it { should exist }
  it { should be_file }
  it { should be_mode 644 }
  its(:content_as_json) { should include("slack" => include("bot_name" => "slack-plugin")) }
end
