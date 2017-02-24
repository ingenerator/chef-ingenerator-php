require 'spec_helper'

describe_resource 'resources::composer_dependencies' do
  let (:resource) { 'composer_dependencies' }
  let (:composer_path) { '/usr/local/bin/composer' }
  let (:lock_exists?) { true }
  let (:test_project_dir) { '/project/current' }
  let (:test_run_as) { 'www-data' }

  let (:node_attributes) do
    { test: { project_dir: test_project_dir, run_as: test_run_as } }
  end

  let (:node_environment) { :anything }

  before(:each) do
    # Need to allow File.exist? to work normally unless stubbed for specific file
    allow(File).to receive(:exist?).with(anything).and_call_original
    allow(File).to receive(:exist?).with(test_project_dir + '/composer.lock').and_return(lock_exists?)

    allow_any_instance_of(Chef::Node).to receive(:node_environment).and_return(node_environment)
  end

  describe 'install' do
    context 'when no composer.lock file' do
      let (:lock_exists?) { false }
      it 'raises an exception' do
        expect { chef_run }.to raise_error RuntimeError, /No lockfile/
      end
    end

    context 'when running as root' do
      let (:test_run_as) { 'root' }
      it 'raises an exception if running as the root user' do
        expect { chef_run }.to raise_error RuntimeError, /as root/
      end
    end

    context 'by default' do
      it 'creates a world-readable global composer cache directory' do
        expect(chef_run).to create_directory('/var/composer/cache').with(
          recursive: true,
          user: 'root',
          mode: 0o777
        )
      end

      it 'uses the project directory as the working directory' do
        expect(chef_run).to run_composer(cwd: '/project/current')
      end

      it 'runs composer as the specified user' do
        expect(chef_run).to run_composer(user: 'www-data')
      end

      it 'sets composer to use the global cache directory' do
        expect(chef_run).to run_composer(environment: { 'COMPOSER_CACHE_DIR' => '/var/composer/cache' })
      end

      context 'outside localdev' do
        let (:node_environment) { :anything }
        it 'runs composer install and optimises the autoloader' do
          expect(chef_run).to run_composer(command: '/usr/local/bin/composer install --no-interaction --prefer-dist --optimize-autoloader --apcu-autoloader')
        end
      end

      context 'in localdev environment' do
        let (:node_environment) { :localdev }

        it 'does not optimise the autoloader or use apcu caching' do
          expect(chef_run).to run_composer(command: '/usr/local/bin/composer install --no-interaction --prefer-dist')
        end
      end
    end

    context 'with customised node attributes' do
      it 'uses a custom composer executable' do
        chef_runner.node.normal['composer']['binary_path'] = '/composer'
        expect(chef_run).to run_composer(command: /^\/composer /)
      end
      it 'uses a custom cache directory' do
        chef_runner.node.normal['composer']['global_cache_dir'] = '/compcache'
        expect(chef_run).to create_directory('/compcache')
        expect(chef_run).to run_composer(environment: { 'COMPOSER_CACHE_DIR' => '/compcache' })
      end

      it 'does not optimise the autoloader' do
        chef_runner.node.normal['composer']['optimize-autoloader?'] = false
        expect(chef_run).to run_composer(command: /install .*(?!--optimize-autoloader)/)
      end

      it 'does not use apcu caching' do
        chef_runner.node.normal['composer']['apcu-autoloader?'] = false
        expect(chef_run).to run_composer(command: /install .*(?!--apcu-autoloader)/)
      end
    end

    def run_composer(match)
      run_execute('install packages').with(match)
    end
  end
end
