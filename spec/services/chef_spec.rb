# frozen_string_literal: true

require 'spec_helper'
require 'json'
set :os, family: 'redhat', release: '9', arch: 'x86_64'

packages = %w[
  redborder-chef-client
]

service = 'chef-client'
config_file = '/etc/chef/client.rb'

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

describe "Checking service_status service for #{service}..." do
  describe service(service) do
    it { should be_enabled }
    it { should be_running }
  end

  describe file(config_file) do
    it { should exist }
    it { should be_file }
  end
end
