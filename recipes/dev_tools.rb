#
# Install standard PHP development tools
#
# Author::  Andrew Coulton (<andrew@ingenerator.com>)
# Cookbook Name:: ingenerator-php
# Recipe:: install_php
#
# Copyright 2012-13, inGenerator Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if is_environment?(:localdev)
  node.default['php']['directives']['xdebug.remote_enable'] = 1
  # assign default vagrant host IP for our vagrant IP range
  node.default['php']['directives']['xdebug.remote_host']   = '10.87.23.1'
  node.default['php']['directives']['xdebug.remote_log']    = '/tmp/xdebug_remote.log'
end

# Install the latest version of xdebug if required
bash 'install latest xdebug' do
  code <<-EOH
    set -o nounset
    set -o errexit
    EXISTING_VER=`php -r "print phpversion('xdebug');"`
    if [ "$EXISTING_VER" = "$XDEBUG_TARGET_VER" ]; then
      echo "Xdebug $EXISTING_VER already installed"
      exit
    fi
    pecl channel-update pecl.php.net
    echo "Installing Xdebug $XDEBUG_TARGET_VER"
    pecl install "xdebug-$XDEBUG_TARGET_VER"
  EOH
  environment "XDEBUG_TARGET_VER" => node['php']['xdebug']['version']
end

file "#{node['php']['ext_conf_dir']}/xdebug.ini" do
  content <<-EOH
    ; configuration for php xdebug module
    zend_extension=xdebug.so
  EOH
end

execute '/usr/sbin/php5enmod xdebug'

# Configure xdebug settings
node.default['php']['xdebug']['idekey']          = 'PHPSTORM'
node.default['php']['xdebug']['ide_server_name'] = node['hostname']

# Install the xdebug CLI wrapper script
template '/usr/local/bin/xdebug' do
  source    'xdebug.erb'
  mode      0755
  variables ({
    :idekey      => node['php']['xdebug']['idekey'],
    :serverName  => node['php']['xdebug']['ide_server_name']
  })
end
