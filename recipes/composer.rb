#
# Install composer globally and set up a shared global cache path - by default
# in /var/composer/cache. Note that your composer.json needs to be set to use
# this path separately.
#

# Presence of this attribute suggests the project is still using zircote/chef-composer
# which conflicts with our new resources.
raise_if_legacy_attributes('composer.install_path', 'composer.global_cache')

composer_binary node['composer']['binary_path'] do
  action [:install, :update]
end
