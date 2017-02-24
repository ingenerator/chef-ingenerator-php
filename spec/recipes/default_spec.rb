require 'spec_helper'

describe 'ingenerator-php::default' do
  let (:chef_runner) { ChefSpec::SoloRunner.new }
  let (:chef_run)    { chef_runner.converge 'ingenerator-php::default' }

  it 'should run the install_php recipe' do
    expect(chef_run).to include_recipe 'ingenerator-php::install_php'
  end

  it 'should run the share_inis recipe' do
    expect(chef_run).to include_recipe 'ingenerator-php::share_inis'
  end

  it 'should run the composer recipe' do
    expect(chef_run).to include_recipe 'ingenerator-php::composer'
  end

  it 'should not run the dev_tools recipe by default' do
    expect(chef_run).not_to include_recipe 'ingenerator-php::dev_tools'
  end

  context 'with node[project][install_dev_tools] set' do
    it "should run the dev_tools recipe" do
      chef_runner.node.normal['project']['install_dev_tools'] = true
      expect(chef_run).to include_recipe 'ingenerator-php::dev_tools'
    end
  end

end
