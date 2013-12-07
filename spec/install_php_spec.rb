require 'spec_helper'

describe 'ingenerator-php::install_php' do
  let (:chef_run) { ChefSpec::Runner.new.converge 'ingenerator-php::install_php' }

  it "installs php from package with the community cookbook recipe" do
    chef_run.should include_recipe "php::package"
  end

  it "does not update pear.php.net" do
    # these are slow and are not a required part of installing php especially as we now use composer
    chef_run.should_not ChefSpec::Matchers::ResourceMatcher.new(:php_pear_channel, :update, 'pear.php.net')
  end

  it "does not update pecl.php.net" do
    chef_run.should_not ChefSpec::Matchers::ResourceMatcher.new(:php_pear_channel, :update, 'pecl.php.net')
  end

  it "writes a common php.ini in /etc/php5/php.ini" do
    chef_run.should render_file('/etc/php5/php.ini').with_content(/About php.ini/)
  end

  it "includes custom directives in the php.ini file" do
    chef_run.node.set['php']['directives']['session.save_path'] = '/tmp/sessions'
    chef_run.converge(described_recipe)

    chef_run.should render_file('/etc/php5/php.ini').with_content(/session.save_path="\/tmp\/sessions"/)
  end

  context "when session.save_path is provided" do
    let (:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['php']['directives']['session.save_path'] = '/tmp/foo/sessions'
        node.set['php']['session_dir']['user']  = 'foo-user'
        node.set['php']['session_dir']['group'] = 'bar-group'
      end.converge(described_recipe)
    end

    it "ensures the path exists" do
      chef_run.should create_directory('/tmp/foo/sessions').with(recursive: true)
    end

    it "ensures the path is private to the user and group specified in node['php']['session_dir']" do
      chef_run.should create_directory('/tmp/foo/sessions').with(
        user:  'foo-user',
        group: 'bar-group',
        mode:  0700
      )
    end
  end

  it "installs the php-apc module from package" do
    chef_run.should install_package "php-apc"
  end

  it "installs the php5-curl module from package" do
    chef_run.should install_package "php5-curl"
  end

  context "with optional modules in node attributes" do
      let (:chef_run) do
        ChefSpec::Runner.new do |node|
          node.set['php']['module_packages']['php-gd'] = true
          node.set['php']['module_packages']['php-apc'] = false
        end.converge(described_recipe)
      end

      it "installs packages for required modules" do
        chef_run.should install_package 'php-gd'
      end

      it "does not install packages for modules that are disabled" do
        chef_run.should_not install_package 'php-apc'
      end
  end

end
