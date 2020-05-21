# frozen_string_literal: true

require_relative "../spec_helper"

describe service "nginx" do
  it { should be_enabled }
  it { should be_running }
end

[80].each do |p|
  describe port p do
    it { should be_listening }
  end
end
