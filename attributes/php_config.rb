# These module packages will be installed during the install_php recipe and should include the
# most common defaults that we always use. Other packages can be added in your application cookbooks.
# Note that the ingenerator-php::dev-tools recipe installs the xdebug package separately
default['php']['module_packages']['php-apc'] = true
default['php']['module_packages']['php5-curl'] = true

# Core directives
default['php']['directives']['allow_call_time_pass_reference'] = 0
default['php']['directives']['disable_functions'] = ''
default['php']['directives']['enable_dl'] = 0
default['php']['directives']['error_reporting'] = 'E_ALL'
default['php']['directives']['expose_php'] = 0
default['php']['directives']['html_errors'] = 1
default['php']['directives']['mail.add_x_header'] = 0
default['php']['directives']['memory_limit'] = '256M'
default['php']['directives']['post_max_size'] = '30M'
default['php']['directives']['serialize_precision'] = 100
default['php']['directives']['upload_max_filesize'] = '30M'
default['php']['directives']['variables_order'] = 'EGPCS'

# Namespaced core
default['php']['directives']['date.timezone'] = 'Europe/London'
default['php']['directives']['session.bug_compat_warn'] = 1
default['php']['directives']['session.gc_max_lifetime'] = 3600
default['php']['directives']['session.save_path'] = '/var/lib/php/session'

# Modules
default['php']['directives']['apc.canonicalize'] = 0
default['php']['directives']['apc.mmap_files_mask'] = '/tmp/apc.94MX1m'
default['php']['directives']['apc.num_files_hint'] = 7500
default['php']['directives']['apc.shm_size'] = '256M'
default['php']['directives']['apc.stat'] = 0
default['php']['directives']['apc.ttl'] = 7200
default['php']['directives']['apc.user_ttl'] = 7200

default['php']['directives']['pdo_mysql.default_socket'] = '/var/run/mysqld/mysqld.sock'

default['php']['session_dir']['user'] = 'www-data'
default['php']['session_dir']['group'] = 'www-data'

# List of php.ini files that should be removed by the share_inis recipe and replaced with links
# to the standard php.ini location
default['php']['share_env_inis']['/etc/php5/cli/php.ini'] = true
default['php']['share_env_inis']['/etc/php5/cgi/php.ini'] = true
