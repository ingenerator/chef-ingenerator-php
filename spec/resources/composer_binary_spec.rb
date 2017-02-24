require 'spec_helper'

describe_resource 'resources::composer_binary' do
  let (:resource) { 'composer_binary' }
  let (:test_path) { '/usr/local/bin/composer' }
  let (:test_action) { nil }
  let (:composer_exists?) { false }

  let (:node_attributes) do
    { test: { path: test_path, action: test_action } }
  end

  before(:each) do
    # Need to allow File.exist? to work normally and only skip for this one
    allow(File).to receive(:exist?).with(anything).and_call_original
    allow(File).to receive(:exist?).with(test_path).and_return(composer_exists?)
  end

  describe 'install' do
    let (:test_action) { :install }
    context 'when composer is not installed in the specified location' do
      let (:composer_exists?) { false }
      it 'downloads the composer installer' do
        expect(chef_run).to create_remote_file('/tmp/composer-setup.php').with(
          mode: 0o755,
          source: 'https://getcomposer.org/installer',
          retries: 2,
          retry_delay: 2
        )
      end

      it 'runs composer-setup to install in the specified path' do
        expect(chef_run).to run_execute('install-composer').with(
          command: 'php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer'
        )
      end

      it 'deletes composer-setup' do
        expect(chef_run).to delete_file('/tmp/composer-setup.php')
      end
    end
    context 'when composer is already installed in the specified location' do
      let (:composer_exists?) { true }
      it 'does not download the installer' do
        expect(chef_run).to_not create_remote_file('/tmp/composer-setup.php')
      end

      it 'does not run the installer' do
        expect(chef_run).to_not run_execute('install-composer')
      end
    end
  end

  describe 'update' do
    let (:test_action) { :update }
    context 'when composer is installed' do
      let (:composer_exists?) { true }
      it 'runs composer self-update' do
        expect(chef_run).to run_execute('/usr/local/bin/composer self-update --no-interaction')
      end
    end

    context 'when composer is not installed' do
      let (:composer_exists?) { false }
      it 'raises an exception' do
        expect { chef_run }.to raise_error RuntimeError, /not installed/
      end
    end
  end
end
