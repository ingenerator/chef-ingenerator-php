# Installs the most recent stable composer binary as a global tool, and updates
# if required.
#
#   composer_binary '/usr/bin/composer' do
#     actions [:install, :update]
#   end
#
resource_name :composer_binary

# Path to install the
property :path, name_property: true, required: true

default_action :install

action :install do
  # Don't need to do any install steps if composer is already present
  unless installed?
    remote_file installer_file do
      mode 0o755
      source 'https://getcomposer.org/installer'
      retries 2
      retry_delay 2
    end

    execute 'install-composer' do
      command installer_command
    end

    file installer_file do
      action :delete
    end
  end
end

action :update do
  raise "Composer is not installed in #{new_resource.path}" unless installed?
  execute new_resource.path + ' self-update --no-interaction'
end

action_class do
  def installer_file
    '/tmp/composer-setup.php'
  end

  def installer_command
    install_dir = ::File.dirname(new_resource.path)
    filename = ::File.basename(new_resource.path)
    "php #{installer_file} --install-dir=#{install_dir} --filename=#{filename}"
  end

  def installed?
    ::File.exist?(new_resource.path)
  end
end
