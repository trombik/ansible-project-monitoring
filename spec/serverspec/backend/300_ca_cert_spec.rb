# frozen_string_literal: true

require_relative "../spec_helper"

ca_root_dir = case os[:family]
              when "freebsd"
                "/usr/local/etc/ssl"
              else
                "/etc/ssl"
              end

describe file "#{ca_root_dir}/ca.pem" do
  it { should exist }
  it { should be_file }
  case test_environment
  when "virtualbox"
    it { should be_mode 644 }
  when "prod"
    it { should be_mode 664 }
  end
  its(:content) { should match(/-----BEGIN CERTIFICATE-----/) }
  its(:content) { should match(/-----END CERTIFICATE-----/) }
end

describe command "openssl x509 -in #{ca_root_dir}/ca.pem -text" do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should eq "" }
  its(:stdout) { should match(/#{Regexp.escape("Issuer: CN = Root CA at i.trombik.org")}/) }
end
