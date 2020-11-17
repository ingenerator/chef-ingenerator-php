# Xdebug attributes
# Only relevant if the `project.install_dev_tools` attribute is set

default['php']['xdebug']['version']         = '2.9.8'

# Used for provisioning the xdebug CLI wrapper script
default['php']['xdebug']['idekey']          = 'PHPSTORM'
default['php']['xdebug']['ide_server_name'] = node['hostname']

# Configure xdebug remote access for local vagrant machines
if is_environment?(:localdev)
  node.default['php']['directives']['xdebug.remote_enable'] = 1
  # assign default vagrant host IP for our vagrant IP range
  node.default['php']['directives']['xdebug.remote_host']   = '10.87.23.1'
  node.default['php']['directives']['xdebug.remote_log']    = '/tmp/xdebug_remote.log'
end
