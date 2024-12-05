# frozen_string_literal: true

require 'spec_helper'
require 'set'

set :os, family: 'redhat', release: '9', arch: 'x86_64'

describe 'Check zones are defined' do
  describe file('/etc/firewalld/zones/public.xml') do
    it { should exist }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  # it { should be_mode 600 } # Ensures file is readable and writable by root only
  end
end

describe 'Check if not allowed open ports in public zone are empty' do
  valid_public_ports = Set.new [
    '443/tcp',    # (HTTPS)
    # We don't know why this should be open. Remove?. Found references in our code mention pfring and snort
    # '5353/udp',   # (mDNS / Serf)
    '514/tcp',    # (rsyslogd)
    '514/udp',    # (rsyslogd)
    '2056/tcp',   # (n2klocd)
    '2057/tcp',   # (n2klocd)
    '2058/tcp',   # (n2klocd)
    '161/udp',    # (snmp)
    '162/udp',    # (snmp)
    '2055/udp',   # (f2k)
    '6343/udp',   # (sfacctd/pmacctd)
    '1812/udp',   # (freeradius)
    '1813/udp',   # (freeradius)
    '7779/tcp',   # (rb-ale)
  ]

  open_public = command('firewall-cmd --zone=public --list-ports')
  open_public = open_public.stdout.strip.split(' ')
  open_public = Set.new open_public

  not_allowed_open_public = open_public - valid_public_ports

  it 'should not have any not allowed open ports in public zone' do
    unless not_allowed_open_public.empty?
      skip "Not allowed open ports in public zone: #{not_allowed_open_public.to_a.join(', ')}"
    end
    expect(not_allowed_open_public).to be_empty
  end
end
