# frozen_string_literal: true

require_relative "../spec_helper"

describe service "monit" do
  it { should be_enabled }
  it { should be_running }
end

[2812].each do |p|
  describe port p do
    it { should be_listening }
  end
end
