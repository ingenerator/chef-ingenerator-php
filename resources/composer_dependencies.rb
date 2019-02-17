# Installs the most recent stable composer binary as a global tool, and updates
# if required.
#
#   composer_binary '/usr/bin/composer' do
#     actions [:install, :update]
#   end
#
resource_name :composer_dependencies

# Path where the project composer.json lives
property :project_dir, String, name_property: true

# Whether to check composer's platform requirements before attempting to install
property :check_platform_reqs, [TrueClass, FalseClass], default: true

# This must be a non-root user for security reasons
property :run_as, String, required: true

default_action :install

action :install do
  raise_unless_lockfile # you're not really deploying unlocked dependencies, right?
  raise RuntimeError, 'Do not run composer as root' if is_root?

  directory cache_dir do
    recursive true
    user      'root'
    mode 0777
  end

  if new_resource.check_platform_reqs
    execute 'check composer platform requirements' do
      command     check_requirements_command
      cwd         new_resource.project_dir
      user        new_resource.run_as
      live_stream true
    end
  end

  execute 'install packages' do
    command install_command
    cwd new_resource.project_dir
    user new_resource.run_as
    environment({
      'COMPOSER_CACHE_DIR' => cache_dir
      })
    live_stream true
  end

end

action_class do

  def cache_dir
    node['composer']['global_cache_dir']
  end

  def check_requirements_command
      cmd = node['composer']['binary_path'].dup
      cmd << ' check-platform-reqs'
      cmd << ' --no-interaction'
      cmd
  end

  def install_command
    cmd = node['composer']['binary_path'].dup
    cmd << ' install'
    cmd << ' --no-interaction'
    cmd << ' --prefer-dist'
    cmd << ' --optimize-autoloader' if optimize_autoloader?
    cmd << ' --apcu-autoloader' if apcu_autoloader?
    cmd
  end

  def optimize_autoloader?
    node['composer']['optimize-autoloader?']
  end

  def apcu_autoloader?
    node['composer']['apcu-autoloader?']
  end

  def raise_unless_lockfile
    lockfile = ::File.join(new_resource.project_dir, 'composer.lock')
    raise RuntimeError, "No lockfile in #{lockfile}" unless ::File.exist? lockfile
  end

  def is_root?
    new_resource.run_as == 'root'
  end

end
