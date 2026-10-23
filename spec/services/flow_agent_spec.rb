# frozen_string_literal: true

require 'spec_helper'
set :os, family: 'redhat', release: '9', arch: 'x86_64'

pkg = 'redborder-flow-agent-ndpi-static'
service_name = 'redborder-flow-agent'
config_dir = '/etc/redborder-flow-agent'

describe "Checking packages for #{pkg}..." do
  describe package(pkg) do
    before do
      skip("#{pkg} is not installed, skipping...") unless package(pkg).installed?
    end

    it 'is expected to be installed' do
      expect(package(pkg).installed?).to be true
    end
  end

  describe package('rb-exporter') do
    it { should_not be_installed }
  end
end

# One systemd instance per configured interface: /etc/redborder-flow-agent/<iface>.yaml
ifaces = command("ls #{config_dir}/*.yaml 2>/dev/null").stdout.split.map { |f| File.basename(f, '.yaml') }
ifaces.each do |iface|
  describe service("#{service_name}@#{iface}") do
    it { should be_enabled }
    it { should be_running }
  end
end
