#
# Installs PHP with standard configuration
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

# Chef's community cookbook only manages one php.ini file - force use of a common file
# which can be shared between cgi, cli and other environments with symlinks
node.override['php']['conf_dir']     = '/etc/php/7.4'
node.override['php']['ext_conf_dir'] = '/etc/php/7.4/mods-available'
node.override['php']['packages']     = %w(php7.4-cgi php7.4 php7.4-dev php7.4-cli php-pear)

apt_repository 'ondrej-ubuntu-php-bionic' do
  uri        'http://ppa.launchpad.net/ondrej/php/ubuntu'
  keyserver  'keyserver.ubuntu.com'
  key        '14AA40EC0831756756D7F66C4F4EA0AAE5267A6C'
  components ['main']
end

include_recipe "php::package"

Ingenerator::Php::PhpModules.module_packages_to_install(node).each do | package_name |
  package package_name
end

directory node['php']['directives']['session.save_path'] do
  action    :create
  recursive true
  user      node['php']['session_dir']['user']
  group     node['php']['session_dir']['group']
  mode      0700
end
