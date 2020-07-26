# frozen_string_literal: true

require_relative "../spec_helper"

packages = case os[:family]
           when "freebsd"
             %w[
               net-mgmt/nagios-plugins
             ]
           when "ubuntu"
             %w[
               monitoring-plugins-basic
             ]
           end

packages.each do |p|
  describe package p do
    it { should be_installed }
  end
end
