# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

describe 'Default Route Interface' do
  management_interface = command("awk '/management_interface:/ { print $2 }' /etc/redborder/rb_init_conf.yml").stdout.strip

  describe command('ip route show default') do
    its(:stdout) { should match /default via .* dev #{management_interface}\s/ }
  end
end
