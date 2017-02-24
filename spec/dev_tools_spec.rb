require 'spec_helper'

describe 'ingenerator-php::dev_tools' do
  let (:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  context "to install latest xdebug" do
    let (:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['php']['xdebug']['version'] = '2.3.3'
        node.normal['php']['ext_conf_dir']      = '/etc/php-extensions'
      end.converge(described_recipe)
    end

    it 'runs a bash script to install expected version' do
      expect(chef_run).to run_bash('install latest xdebug').with(
        environment: { 'XDEBUG_TARGET_VER' => '2.3.3' }
      )
    end

    it 'provisions xdebug module ini file' do
      expect(chef_run).to create_file('/etc/php-extensions/xdebug.ini').with(
        content: /zend_extension=xdebug.so/
      )
    end

    it 'enables the xdebug module' do
      expect(chef_run).to run_execute('/usr/sbin/php5enmod xdebug')
    end
  end

  context "with configured CLI debugging options" do
    let (:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['php']['xdebug']['idekey'] = 'FOO'
        node.normal['php']['xdebug']['ide_server_name'] = 'foo_server'
      end.converge(described_recipe)
    end

    it "installs the xdebug wrapper command as an executable" do
      expect(chef_run).to create_template('/usr/local/bin/xdebug').with(
        mode: 0755
      )
      expect(chef_run).to render_file('/usr/local/bin/xdebug').with_content(/^#!\/bin\/bash/)
    end

    it "sets the xdebug idekey from the node attributes" do
      expect(chef_run).to render_file('/usr/local/bin/xdebug').with_content(/^export XDEBUG_CONFIG="idekey=FOO"$/m)
    end

    it "sets the IDE server name from the node attributes" do
      expect(chef_run).to render_file('/usr/local/bin/xdebug').with_content(/^export PHP_IDE_CONFIG="serverName=foo_server"$/m)
    end
  end

  context "with default CLI debugging options" do
    it "sets the xdebug idekey to PHPSTORM" do
      expect(chef_run).to render_file('/usr/local/bin/xdebug').with_content(/^export XDEBUG_CONFIG="idekey=PHPSTORM"$/m)
    end

    it "sets the xdebug server name to the hostname" do
      hostname = chef_run.node['hostname']
      pattern = Regexp.new('^export PHP_IDE_CONFIG="serverName='+Regexp.escape(hostname)+'"$', Regexp::MULTILINE)
      expect(chef_run).to render_file('/usr/local/bin/xdebug').with_content(pattern)
    end

  end

  context "when running outside the :localdev environment" do
    before do
	    allow_any_instance_of(Chef::Recipe).to receive(:node_environment).and_return(:buildslave)
    end

	it "does not initialise any xdebug directives" do
	  expect(chef_run.node['php']['directives']).not_to have_key('xdebug.remote_enable')
	  expect(chef_run.node['php']['directives']).not_to have_key('xdebug.remote_host')
	  expect(chef_run.node['php']['directives']).not_to have_key('xdebug.remote_log')
	end
  end

  context "when running in the :localdev environment" do
    before do
      allow_any_instance_of(Chef::Recipe).to receive(:node_environment).and_return(:localdev)
    end

    it "initialises xdebug to support remote debugging on ingenerator vagrant box" do
      expect(chef_run.node['php']['directives']['xdebug.remote_enable']).to eq(1)
      expect(chef_run.node['php']['directives']['xdebug.remote_host']).to eq('10.87.23.1')
      expect(chef_run.node['php']['directives']['xdebug.remote_log']).to eq('/tmp/xdebug_remote.log')
    end
  end

end
