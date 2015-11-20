require 'spec_helper'

describe 'ingenerator-php::dev_tools' do
  let (:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it 'should run the chef_sugar recipe' do
    expect(chef_run).to include_recipe 'chef-sugar::default'
  end

  context "to install latest xdebug" do
	let (:chef_run) do
	  ChefSpec::SoloRunner.new do |node|
		node.set['php']['xdebug']['version'] = '2.3.3'
	  end.converge(described_recipe)
	end

    it "updates the pecl pear channel" do
      expect(chef_run).to ChefSpec::Matchers::ResourceMatcher.new(:php_pear_channel, :update, 'pecl.php.net')
    end

    it "installs specified xdebug version from pecl" do
      expect(chef_run).to ChefSpec::Matchers::ResourceMatcher.new(:php_pear, :install, 'xdebug').with(
        version:  '2.3.3',
      )
    end
  end

  context "with configured CLI debugging options" do
    let (:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.set['php']['xdebug']['idekey'] = 'FOO'
        node.set['php']['xdebug']['ide_server_name'] = 'foo_server'
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

  context "when running outside vagrant" do
    before do
	  expect(Chef::Sugar::Vagrant).to receive(:vagrant?).and_return(false)
    end

	it "does not initialise any xdebug directives" do
	  expect(chef_run.node['php']['directives']).not_to have_key('xdebug.remote_enable')
	  expect(chef_run.node['php']['directives']).not_to have_key('xdebug.remote_host')
	  expect(chef_run.node['php']['directives']).not_to have_key('xdebug.remote_log')
	end
  end

  context "when running under vagrant" do
    before do
      expect(Chef::Sugar::Vagrant).to receive(:vagrant?).and_return(true)
    end

    it "initialises xdebug to support remote debugging on ingenerator vagrant box" do
      expect(chef_run.node['php']['directives']['xdebug.remote_enable']).to eq(1)
      expect(chef_run.node['php']['directives']['xdebug.remote_host']).to eq('10.87.23.1')
      expect(chef_run.node['php']['directives']['xdebug.remote_log']).to eq('/tmp/xdebug_remote.log')
    end
  end

end
