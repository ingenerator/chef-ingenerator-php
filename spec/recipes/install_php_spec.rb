require 'spec_helper'

describe 'ingenerator-php::install_php' do
  let (:chef_runner) { ChefSpec::SoloRunner.new }
  let (:chef_run)    { chef_runner.converge 'ingenerator-php::install_php' }

  it "installs php from package with the community cookbook recipe" do
    expect(chef_run).to include_recipe "php::package"
  end

  it "does not update pear.php.net" do
    # these are slow and are not a required part of installing php especially as we now use composer
    expect(chef_run).not_to ChefSpec::Matchers::ResourceMatcher.new(:php_pear_channel, :update, 'pear.php.net')
  end

  it "does not update pecl.php.net" do
    expect(chef_run).not_to ChefSpec::Matchers::ResourceMatcher.new(:php_pear_channel, :update, 'pecl.php.net')
  end

  it "writes a common php.ini in /etc/php/7.2/php.ini" do
    expect(chef_run).to render_file('/etc/php/7.2/php.ini').with_content(/About php.ini/)
  end

  it "includes custom directives in the php.ini file" do
    chef_run.node.normal['php']['directives']['session.save_path'] = '/tmp/sessions'
    chef_run.converge(described_recipe)

    expect(chef_run).to render_file('/etc/php/7.2/php.ini').with_content(/session.save_path=\/tmp\/sessions/)
  end

  context "when session.save_path is provided" do
    let (:chef_run) do
      ChefSpec::SoloRunner.new do |node|
        node.normal['php']['directives']['session.save_path'] = '/tmp/foo/sessions'
        node.normal['php']['session_dir']['user']  = 'foo-user'
        node.normal['php']['session_dir']['group'] = 'bar-group'
      end.converge(described_recipe)
    end

    it "ensures the path exists" do
      expect(chef_run).to create_directory('/tmp/foo/sessions').with(recursive: true)
    end

    it "ensures the path is private to the user and group specified in node['php']['session_dir']" do
      expect(chef_run).to create_directory('/tmp/foo/sessions').with(
        user:  'foo-user',
        group: 'bar-group',
        mode:  0700
      )
    end
  end

  %w(php-apcu php-apcu-bc php7.2-curl php7.2-mbstring).each do | pkg |
    it "installs the #{pkg} module from package" do
      expect(chef_run).to install_package pkg
    end
  end

  context "with optional modules in node attributes" do
      let (:chef_run) do
        ChefSpec::SoloRunner.new do |node|
          node.normal['php']['module_packages']['php-gd'] = true
          node.normal['php']['module_packages']['php-apcu'] = false
        end.converge(described_recipe)
      end

      it "installs packages for required modules" do
        expect(chef_run).to install_package 'php-gd'
      end

      it "does not install packages for modules that are disabled" do
        expect(chef_run).not_to install_package 'php-apcu'
      end
  end

  context 'with invalid legacy packages in node attributes' do

    it 'throws if requesting any package with a php5 name' do
      chef_runner.node.default['php']['module_packages']['php5-imagick'] = true
      expect { chef_run }.to raise_exception /php5 package php5-imagick/
    end

    it 'throws if requesting php-apc name' do
      chef_runner.node.default['php']['module_packages']['php-apc'] = true
      expect { chef_run }.to raise_exception /php5 package php-apc/
    end

    it 'throws if requesting multiple bad packages' do
      chef_runner.node.default['php']['module_packages']['php5-any'] = true
      chef_runner.node.default['php']['module_packages']['php5-other'] = true
      expect { chef_run }.to raise_exception /php5 package php5-any, php5-other/
    end

  end


end
