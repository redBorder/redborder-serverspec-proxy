# frozen_string_literal: true

require 'spec_helper'
require 'json'
set :os, family: 'redhat', release: '9', arch: 'x86_64'

service = 'redborder-sflow2kafka'
port = 6343 # sflow listener (udp)
stats_port = 7984 # /stats and /health endpoint (tcp)
config_file = "/etc/#{service}/config.json"
service_status = command("systemctl is-enabled #{service}").stdout.strip

packages = %w[cookbook-rb-sflow2kafka redborder-sflow2kafka x2kafka]

describe "Checking packages for #{service}..." do
  packages.each do |package|
    describe package(package) do
      before do
        skip("#{package} is not installed, skipping...") unless package(package).installed?
      end

      it 'is expected to be installed' do
        expect(package(package).installed?).to be true
      end
    end
  end
end

if service_status == 'enabled'
  describe "Checking #{service_status} service for #{service}..." do
    describe service(service) do
      it { should be_enabled }
      it { should be_running }
    end

    # no protocol filter: specinfra adds -4 to ss and x2kafka may listen on a dual-stack socket
    describe port(port) do
      it { should be_listening }
    end

    describe port(stats_port) do
      it { should be_listening }
    end

    describe file(config_file) do
      it { should exist }
      it { should be_file }
      it { should be_owned_by 'root' }
    end

    describe 'Config file is valid JSON' do
      it 'should be parseable' do
        expect { JSON.parse(file(config_file).content) }.not_to raise_error
      end
    end

    describe command("curl -sf http://localhost:#{stats_port}/health") do
      its(:exit_status) { should eq 0 }
    end
  end
end

if service_status == 'disabled'
  describe "Checking #{service_status} service for #{service}..." do
    describe service(service) do
      it { should_not be_enabled }
      it { should_not be_running }
    end

    describe port(port) do
      it { should_not be_listening }
    end

    describe port(stats_port) do
      it { should_not be_listening }
    end
  end
end

# sfacctd (pmacct) was replaced by redborder-sflow2kafka and must not compete for udp 6343
describe service('sfacctd') do
  it { should_not be_running }
end
