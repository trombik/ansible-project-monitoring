require "spec_helper"
require "serverspec"

# rubocop:disable Style/GlobalVars
$BACKEND_URL = "https://localhost:8080"
certs_dir = case os[:family]
            when "freebsd"
              "/usr/local/etc/ssl/certs"
            else
              "/etc/ssl/certs"
            end
$CA_CERT = "#{certs_dir}/../ca.pem"
ca_cert = $CA_CERT
# rubocop:enable Style/GlobalVars

require_relative "common_spec"

ports_http = [
  8080,       # API
  8081,       # agent
  2379, 2380, # etcd
  3000        # Web UI
]

describe file certs_dir do
  it { should exist }
  it { should be_directory }
end

describe file "#{certs_dir}/localhost.pem" do
  it { should exist }
  it { should be_file }
  its(:content) { should match(/-----BEGIN CERTIFICATE-----/) }
end

ports_http.each do |port|
  describe command "(echo 'GET / HTTP/1.0'; echo; sleep 1) | openssl s_client -connect 127.0.0.1:#{port} -servername localhost -CAfile #{ca_cert}" do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/issuer=CN = Sensu Test CA/) }
    its(:stdout) { should match(/subject=CN = localhost/) }
    its(:stdout) { should match(/-----BEGIN CERTIFICATE-----/) }
    its(:stdout) { should match(%r{HTTP/1\.0 \d{3}}) }
  end
end
