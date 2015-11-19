require 'spec_helper'

describe 'ingenerator-php::dev_tools' do
  let (:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it "installs xdebug as a package" do
    expect(chef_run).to install_package('php5-xdebug')
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
end
