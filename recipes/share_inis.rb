#
# Replace package-installed php.ini files for CGI/CLI/etc environments with links to
# the central php.ini managed by this cookbook.
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

node['php']['share_env_inis'].each do |ini_path, should_share|
  if /php5/.match(ini_path)
    raise ArgumentError.new("Your project has an invalid legacy node['php']['share_env_inis']['#{ini_path}'] - it should be /etc/php/7.4/...")
  end

  next unless should_share
  ini_path = ini_path.dup

  file ini_path do
    action :delete
    not_if { File.symlink?(ini_path) }
  end

  link ini_path do
    to node['php']['conf_dir']+'/php.ini'
    not_if { File.symlink?(ini_path) }
  end
end
