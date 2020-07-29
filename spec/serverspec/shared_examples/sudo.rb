# frozen_string_literal: true

shared_examples "a host with pre-installed sudoers files removed" do
  sudoers_dir = case os[:family]
                when "freebsd"
                  "/usr/local/etc/sudo"
                when "ubuntu"
                  "/etc/sudoers.d"
                end
  %w[root vagrant].each do |f|
    describe file "#{sudoers_dir}/#{f}" do
      it { should_not exist }
    end
  end
end
