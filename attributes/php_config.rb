#
# Author:: Andrew Coulton(<andrew@ingenerator.com>)
# Cookbook Name:: ingenerator-php
# Attribute:: php_config
#
# Copyright 2012-13, Opscode, Inc.
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

# These module packages will be installed by the php::package recipe from the community cookbook
# and should include the most common defaults that we always use. Other packages can be added
# in your application cookbooks.
# Note that the ingenerator-php::dev-tools recipe installs the xdebug package separately
default['php']['packages'] = [
  'php-apc',
  'php5-curl'
]

default['php']['directives'] = {
  # Core
  'allow_call_time_pass_reference'       => 0,
  'disable_functions'                    => '',
  'enable_dl'                            => 0,
  'error_reporting'                      => 'E_ALL',
  'expose_php'                           => 0,
  'html_errors'                          => 1,
  'mail.add_x_header'                    => 0,
  'memory_limit'                         => '256M',
  'post_max_size'                        => '30M',
  'serialize_precision'                  => 100,
  'upload_max_filesize'                  => '30M',
  'variables_order'                      => 'EGPCS',

  # Namespaced core
  'date.timezone'                        => 'Europe/London',
  'session.bug_compat_warn'              => 1,
  'session.gc_max_lifetime'              => 3600,
  'session.save_path'                    => '/var/lib/php/session',

  # Modules
  'apc.canonicalize'                     => 0,
  'apc.mmap_files_mask'                  => '/tmp/apc.94MX1m',
  'apc.num_files_hint'                   => 7500,
  'apc.shm_size'                         => '256M',
  'apc.stat'                             => 0,
  'apc.ttl'                              => 7200,
  'apc.user_ttl'                         => 7200,

  'pdo_mysql.default_socket'             => '/var/run/mysqld/mysqld.sock',
}

default['php']['session_dir'] = {
  'user'  => 'www-data',
  'group' => 'www-data'
}

# List of php.ini files that should be removed by the share_inis recipe and replaced with links
# to the standard php.ini location
default['php']['share_env_inis'] = {
  '/etc/php5/cli/php.ini' => true,
  '/etc/php5/cgi/php.ini' => true
}
