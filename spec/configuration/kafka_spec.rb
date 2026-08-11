# frozen_string_literal: true

require 'spec_helper'
set :os, family: 'redhat', release: '9', arch: 'x86_64'
pipelines = %w[
  rb_flow
  rb_nmsp
  rb_state
  rb_vault
  sflow
]

describe 'Check logstash config' do
  describe file('/etc/kafka/topics_definitions.yml') do
    it { should exist }
    it { should be_file }
    it { should be_readable }
    it { should be_writable.by_user('kafka') }
    it { should_not be_writable.by('others') }
    it { should_not be_executable }
    pipelines.each do |pipeline|
      it { should contain pipeline }
    end
  end
end
