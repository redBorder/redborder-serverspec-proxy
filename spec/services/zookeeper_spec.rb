# frozen_string_literal: true

require 'spec_helper'
require 'json'
set :os, family: 'redhat', release: '9', arch: 'x86_64'

packages = %w[
  zookeeper libzookeeper nmap-ncat
]

service = 'zookeeper'
port = 2181

describe "Checking packages for #{service}..." do
  packages.each do |package|
    describe package(package) do
      it 'is expected to be installed' do
        expect(package(package).installed?).to be true
      end
    end
  end
end

service_status = command("systemctl is-enabled #{service}").stdout.strip
describe "Checking #{service_status} service for #{service}..." do
  describe service(service) do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(port) do
    it { should be_listening }
  end
end
