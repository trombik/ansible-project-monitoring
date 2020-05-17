# frozen_string_literal: true

require_relative "../spec_helper"

admin_user = credentials_yaml["sensu_go_backend_admin_account"]
admin_pass = credentials_yaml["sensu_go_backend_admin_password"]

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
