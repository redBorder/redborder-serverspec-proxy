# frozen_string_literal: true

require 'spec_helper'
require 'json'
set :os, family: 'redhat', release: '9', arch: 'x86_64'

packages = %w[
  rsyslog
]

service = 'rsyslog'
config_directory = '/etc/rsyslog.d/'
files = %w[
  01-server.conf 02-general.conf 20-redborder.conf 99-parse_rfc5424.conf
]
port = 514

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

service_status = command("systemctl is-enabled #{service}").stdout
service_status = service_status.strip

if service_status == 'enabled'
  describe "Checking #{service_status} service for #{service}..." do
    describe service(service) do
      it { should be_enabled }
      it { should be_running }
    end

    describe 'Configuration files and directories' do
      [config_directory, *files.map { |file| "#{config_directory}/#{file}" }].each do |file_path|
        describe file(file_path) do
          it { should exist }
          it { should send(File.directory?(file_path) ? :be_directory : :be_file) }
        end
      end
    end

    describe port(port) do
      it { should be_listening }
    end
  end
end

if service_status == 'disabled'
  describe "Checking #{service_status} service for #{service}..." do
    describe service(service) do
      it { should_not be_enabled }
      it { should_not be_running }
    end

    describe 'Configuration files and directories' do
      [config_directory, *files.map { |file| "#{config_directory}/#{file}" }].each do |file_path|
        describe file(file_path) do
          it { should_not exist }
        end
      end
    end

    describe port(port) do
      it { should_not be_listening }
    end
  end
end
