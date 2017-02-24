#
# Attributes controlling the global composer installation
default['composer']['binary_path'] = '/usr/local/bin/composer'
default['composer']['global_cache_dir'] = '/var/composer/cache'
default['composer']['optimize-autoloader?'] = node.not_environment?(:localdev)
default['composer']['apcu-autoloader?'] = node.not_environment?(:localdev)
