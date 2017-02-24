require 'spec_helper'

describe 'ingenerator-php::share_inis' do
  let (:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.normal['php']['share_env_inis']['/etc/php5/cgi/php.ini'] = false
      node.normal['php']['share_env_inis']['/etc/php5/apache2/php.ini'] = true
    end.converge(described_recipe)
  end

  let (:php_conf_dir) { chef_run.node['php']['conf_dir'] }

  context "when node['share_env_inis'][filename] is true" do
    context "and the file has not yet been replaced with a link" do
      before(:each) do
        allow(File).to receive('symlink?').and_return true
        allow(File).to receive('symlink?').with('/etc/php5/apache2/php.ini').and_return false
      end

      it "removes old static ini files" do
        expect(chef_run).to delete_file('/etc/php5/apache2/php.ini')
      end

      it "links ini file path to the shared ini file" do
        expect(chef_run).to create_link('/etc/php5/apache2/php.ini')
        link = chef_run.link('/etc/php5/apache2/php.ini')
        expect(link).to link_to("#{php_conf_dir}/php.ini")
      end
    end

    context "and the file is already a symlink" do
      before(:each) do
        allow(File).to receive('symlink?').and_return false
        allow(File).to receive('symlink?').with('/etc/php5/apache2/php.ini').and_return(true)
      end

      it "does not delete the file" do
        expect(chef_run).not_to delete_file('/etc/php5/apache2/php.ini')
      end

      it "does not create a new link" do
        expect(chef_run).not_to create_link('/etc/php5/apache2/php.ini')
      end

    end
  end

  context "when node['share_env_inis'][filename] is false" do
    it "does not touch existing static ini files" do
      expect(chef_run).not_to delete_file('/etc/php5/cgi/php.ini')
      expect(chef_run).not_to create_link('/etc/php5/cgi/php.ini')
    end
  end

  context "with default configuration" do
    let (:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

    it "shares configuration for CLI" do
      expect(chef_run.node['php']['share_env_inis']['/etc/php5/cli/php.ini']).to be true
    end

    it "shares configuration for CGI" do
      expect(chef_run.node['php']['share_env_inis']['/etc/php5/cgi/php.ini']).to be true
    end

    it "does not contain configuration for apache" do
      expect(chef_run.node['php']['share_env_inis']).not_to have_key('/etc/php5/apache2/php.ini')
    end
  end

end
