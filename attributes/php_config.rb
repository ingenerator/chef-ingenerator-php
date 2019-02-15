# These module packages will be installed during the install_php recipe and should include the
# most common defaults that we always use. Other packages can be added in your application cookbooks.
# Note that the ingenerator-php::dev-tools recipe installs the xdebug package separately
default['php']['module_packages']['php-apcu'] = true
default['php']['module_packages']['php-apcu-bc'] = true
default['php']['module_packages']['php7.2-curl'] = true

# Core directives
default['php']['directives']['allow_call_time_pass_reference'] = 0
default['php']['directives']['disable_functions'] = ''
default['php']['directives']['enable_dl'] = 0
default['php']['directives']['expose_php'] = 0
default['php']['directives']['mail.add_x_header'] = 0
default['php']['directives']['memory_limit'] = '256M'
default['php']['directives']['post_max_size'] = '30M'
default['php']['directives']['serialize_precision'] = 100
default['php']['directives']['upload_max_filesize'] = '30M'
default['php']['directives']['variables_order'] = 'EGPCS'

# Error handling / reporting
default['php']['directives']['error_reporting'] = 'E_ALL'
default['php']['directives']['html_errors'] = 0
default['php']['directives']['log_errors'] = 1
default['php']['directives']['error_log'] = 'syslog'

if node.is_environment?(:localdev, :buildslave)
  default['php']['directives']['display_errors'] = 1
  default['php']['directives']['display_startup_errors'] = 1
else
  default['php']['directives']['display_errors'] = 0
  default['php']['directives']['display_startup_errors'] = 0
end

# Namespaced core
default['php']['directives']['date.timezone'] = 'Europe/London'
default['php']['directives']['session.bug_compat_warn'] = 1
default['php']['directives']['session.gc_max_lifetime'] = 3600
default['php']['directives']['session.save_path'] = '/var/lib/php/session'

# Opcode caching
if node.is_environment?(:localdev)
  default['php']['directives']['opcache.validate_timestamps'] = 1
  default['php']['directives']['opcache.revalidate_freq'] = 0
else
  default['php']['directives']['opcache.validate_timestamps'] = 0
end
default['php']['directives']['opcache.memory_consumption'] = '128M'
default['php']['directives']['opcache.max_accelerated_files'] = 7963
## NB: configure opcache.file_cache_fallback when we go to php7

# APC caching (for user caching, not opcodes)
default['php']['directives']['apc.shm_size'] = '256M'
default['php']['directives']['apc.user_ttl'] = 7200

default['php']['directives']['pdo_mysql.default_socket'] = '/var/run/mysqld/mysqld.sock'

default['php']['session_dir']['user'] = 'www-data'
default['php']['session_dir']['group'] = 'www-data'

# List of php.ini files that should be removed by the share_inis recipe and replaced with links
# to the standard php.ini location
default['php']['share_env_inis']['/etc/php/7.2/cli/php.ini'] = true
default['php']['share_env_inis']['/etc/php/7.2/cgi/php.ini'] = true
