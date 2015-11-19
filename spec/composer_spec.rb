require 'spec_helper'

describe 'ingenerator-php::composer' do
  let (:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
  
  it "installs composer as a global binary" do
    expect(chef_run).to ChefSpec::Matchers::ResourceMatcher.new(:composer, :install, chef_run.node['composer']['install_path'])
  end
  
  it "updates to the most recent composer if required" do
    expect(chef_run).to ChefSpec::Matchers::ResourceMatcher.new(:composer, :update, chef_run.node['composer']['install_path'])
  end
  
  it "creates a shared composer cache directory owned by the configured user" do
    config = chef_run.node['composer']['global_cache']
    expect(chef_run).to create_directory(config['path']).with(
      user:      config['user'],
      group:     config['group'],
      recursive: true
    )
  end
  
  it "makes the shared composer cache world-writeable" do
    config = chef_run.node['composer']['global_cache']
    expect(chef_run).to create_directory(config['path']).with(
      mode:      0777
    )
  end
  
  context "when defining configuration" do
    it "sets the composer global install path to /usr/local/bin" do
      expect(chef_run.node['composer']['install_path']).to eq('/usr/local/bin')
    end
    
    it "sets the composer cache path to /var/composer/cache" do
      expect(chef_run.node['composer']['global_cache']['path']).to eq('/var/composer/cache')
    end
    
    it "sets the composer cache to be owned by root" do
      expect(chef_run.node['composer']['global_cache']['user']).to eq('root')
      expect(chef_run.node['composer']['global_cache']['group']).to eq('root')
    end
  end
  
end
