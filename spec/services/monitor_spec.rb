# frozen_string_literal: true

require 'spec_helper'
set :os, family: 'redhat', release: '9', arch: 'x86_64'

describe package('redborder-monitor') do
  it { should be_installed }
end

describe service('redborder-monitor') do
  it { should be_enabled }
  it { should be_running }
end
