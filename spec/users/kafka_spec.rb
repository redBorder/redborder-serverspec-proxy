# frozen_string_literal: true

require 'spec_helper'
set :os, family: 'redhat', release: '9', arch: 'x86_64'

pkg = usr = 'kafka'
describe user(usr) do
  before(:all) do
    # Depends on the existence of any sensor. 
    # After installation, there is no sensor
    skip("Package #{pkg} is not installed") unless package(pkg).installed?
  end
  it { should exist }
  it { should have_login_shell('/sbin/nologin') }
end
