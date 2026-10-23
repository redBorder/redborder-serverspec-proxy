# frozen_string_literal: true

require 'spec_helper'
set :os, family: 'redhat', release: '9', arch: 'x86_64'

if interface('ens160').exists?
  describe interface('ens160') do
    it { should exist }
  end
else
  describe 'Network interface ens160' do
    skip 'Interface ens160 does not exist on this system.'
  end
end
