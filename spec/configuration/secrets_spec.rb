# frozen_string_literal: true

require 'spec_helper'
set :os, family: 'redhat', release: '9', arch: 'x86_64'

# No credentials or keys in plaintext on persistent storage (rb-common::harden_secrets)

describe 'Memory stays off disk' do
  # sensors may have no swap at all
  describe command('swapon --show=NAME --noheadings') do
    its(:stdout) { should_not match(%r{^/dev/(sd|vd|nvme|mapper/rl)}) }
  end

  describe file('/proc/cmdline') do
    its(:content) { should_not match(/resume=/) }
  end

  describe command("grep '^core_collector ' /etc/kdump.conf 2>/dev/null || echo none") do
    its(:stdout) { should match(/\A(core_collector makedumpfile --dump-dmesg|none)\n\z/) }
  end

  describe command('find /var/crash -name vmcore -size +10M 2>/dev/null | wc -l') do
    its(:stdout) { should match(/^0$/) }
  end

  describe command('systemd-analyze cat-config systemd/coredump.conf') do
    its(:stdout) { should match(/^Storage=none/) }
  end

  describe command('sysctl -n fs.suid_dumpable') do
    its(:stdout) { should eq "0\n" }
  end

  describe command('find /var/lib/systemd/coredump -type f') do
    its(:stdout) { should eq '' }
  end
end

describe 'Chef keeps no secrets on disk' do
  describe file('/etc/chef/client.rb') do
    it { should contain 'file_backup_path "/run/chef-backup"' }
    it { should contain(/^diff_disabled true$/) }
  end

  describe command('find /var/chef/backup -type f') do
    its(:stdout) { should eq '' }
  end

  describe file('/etc/chef/client.pem') do
    it { should be_mode 640 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
  end
end
