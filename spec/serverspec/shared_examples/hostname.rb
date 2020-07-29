# frozen_string_literal: true

require "multi_json"

shared_examples "a host with a valid hostname" do
  describe command("env ANSIBLE_NOCOLOR=y ansible -m setup -i /dev/null localhost") do
    let(:command_output_as_json) { MultiJson.load(subject.stdout.gsub("localhost | SUCCESS =>", "")) }

    its(:exit_status) { should eq 0 }
    it "outputs a valid JSON" do
      expect { command_output_as_json }.not_to raise_error
    end
    it "contains correct ansible_fqdn" do
      expect(command_output_as_json).to include("ansible_facts" => include("ansible_fqdn" => ENV["TARGET_HOST"]))
    end
    it "contains correct ansible_hostname" do
      expect(command_output_as_json).to include("ansible_facts" => include("ansible_hostname" => ENV["TARGET_HOST"].split(".").first))
    end
  end
end
