require 'spec_helper'

describe 'ingenerator-php::share_inis' do
  let (:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['php']['share_env_inis']['/etc/php5/cgi/php.ini'] = false
      node.set['php']['share_env_inis']['/etc/php5/apache2/php.ini'] = true
    end.converge(described_recipe)
  end

  let (:php_conf_dir) { chef_run.node['php']['conf_dir'] }

  context "when node['share_env_inis'][filename] is true" do
    context "and the file has not yet been replaced with a link" do
      before(:each) do
        File.stub('symlink?').and_return true
        File.stub('symlink?').with('/etc/php5/apache2/php.ini').and_return false
      end

      it "removes old static ini files" do
        chef_run.should delete_file('/etc/php5/apache2/php.ini')
      end

      it "links ini file path to the shared ini file" do
        chef_run.should create_link('/etc/php5/apache2/php.ini')
        link = chef_run.link('/etc/php5/apache2/php.ini')
        link.should link_to("#{php_conf_dir}/php.ini")
      end
    end

    context "and the file is already a symlink" do
      before(:each) do
        File.stub('symlink?').and_return false
        File.stub('symlink?').with('/etc/php5/apache2/php.ini').and_return(true)
      end

      it "does not delete the file" do
        chef_run.should_not delete_file('/etc/php5/apache2/php.ini')
      end

      it "does not create a new link" do
        chef_run.should_not create_link('/etc/php5/apache2/php.ini')
      end

    end
  end

  context "when node['share_env_inis'][filename] is false" do
    it "does not touch existing static ini files" do
      chef_run.should_not delete_file('/etc/php5/cgi/php.ini')
      chef_run.should_not create_link('/etc/php5/cgi/php.ini')
    end
  end

  context "with default configuration" do
    let (:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it "shares configuration for CLI" do
      chef_run.node['php']['share_env_inis']['/etc/php5/cli/php.ini'].should be true
    end

    it "shares configuration for CGI" do
      chef_run.node['php']['share_env_inis']['/etc/php5/cgi/php.ini'].should be true
    end

    it "does not contain configuration for apache" do
      chef_run.node['php']['share_env_inis'].should_not have_key('/etc/php5/apache2/php.ini')
    end
  end

end
