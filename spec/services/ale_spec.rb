# frozen_string_literal: true

require 'spec_helper'
require 'set'

set :os, family: 'redhat', release: '9', arch: 'x86_64'

service = pkg = 'redborder-ale'

describe "Checking packages for #{service}..." do
  describe package(pkg) do
    before do
      skip("#{pkg} is not installed, skipping...") unless package(pkg).installed?
    end

    it 'is expected to be installed' do
      expect(package(pkg).installed?).to be true
    end
  end
end

service_status = command("systemctl is-enabled #{service}").stdout.strip
describe "Checking #{service_status} service for #{service}..." do
  describe service(service) do
    if service_status == 'enabled'
      it { should be_enabled }
      it { should be_running }
    elsif service_status == 'disabled'
      it { should_not be_enabled }
      it { should_not be_running }
    end
  end
end
