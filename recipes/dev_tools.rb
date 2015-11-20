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

include_recipe 'chef-sugar::default'
if vagrant?
  node.default['php']['directives']['xdebug.remote_enable'] = 1
  # assign default vagrant host IP for our vagrant IP range
  node.default['php']['directives']['xdebug.remote_host']   = '10.87.23.1'
  node.default['php']['directives']['xdebug.remote_log']    = '/tmp/xdebug_remote.log'
end

# Install the latest version of xdebug if required
# @todo: could we skip the pecl update if we already have the right xdebug version?
php_pear_channel 'pecl.php.net' do
  action :update
end

php_pear 'xdebug' do
  action  :upgrade
  version node['php']['xdebug']['version']
end

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
