# Xdebug attributes
# Only relevant if the `project.install_dev_tools` attribute is set

default['php']['xdebug']['version']         = '2.3.3'

# Used for provisioning the xdebug CLI wrapper script
default['php']['xdebug']['idekey']          = 'PHPSTORM'
default['php']['xdebug']['ide_server_name'] = node['hostname']
