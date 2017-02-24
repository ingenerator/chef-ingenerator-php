# Installs the default PHP configuration, with all required packages, ini files,
# and a global composer executable.
#
# Author::  Andrew Coulton (<andrew@ingenerator.com>)
# Cookbook Name:: ingenerator-php
# Recipe:: default
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

include_recipe "ingenerator-php::install_php"
include_recipe "ingenerator-php::share_inis"

if node['project']['install_dev_tools']
  include_recipe "ingenerator-php::dev_tools"
end

include_recipe "ingenerator-php::composer"
