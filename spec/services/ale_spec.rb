# frozen_string_literal: true

require 'spec_helper'
set :os, family: 'redhat', release: '9', arch: 'x86_64'

service = 'redborder-ale'
service_status = command("systemctl is-enabled #{service}").stdout.strip
packages = %w[redborder-ale]

describe "Checking #{service_status} service for #{service}..." do
  describe service(service) do
    if service_status == 'enabled'
      it { should be_enabled }
      it { should be_running }
      expect(packages.installed?).to be true
    elsif service_status == 'disabled'
      it { should_not be_enabled }
      it { should_not be_running }
    end
  end
end

command_to_check = '/usr/lib/rvm/rubies/ruby-2.7.5/bin/ruby'
describe command("sudo -u #{service} #{command_to_check} -e 'exit 0' 2>&1") do
  its(:exit_status) { should eq 0 }
end
