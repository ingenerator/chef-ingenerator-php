require 'spec_helper'

describe 'ingenerator-php::default' do
  let (:chef_run) { ChefSpec::Runner.new.converge 'ingenerator-php::default' }

  it 'should run the install_php recipe' do
    chef_run.should include_recipe 'ingenerator-php::install_php'
  end

  it 'should run the share_inis recipe' do
    chef_run.should include_recipe 'ingenerator-php::share_inis'
  end

  it 'should run the composer recipe' do
    chef_run.should include_recipe 'ingenerator-php::composer'
  end

  it 'should not run the dev_tools recipe by default' do
    chef_run.should_not include_recipe 'ingenerator-php::dev_tools'
  end

  context 'with node[project][install_dev_tools] set' do
    let (:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set['project']['install_dev_tools'] = true
      end.converge(described_recipe)
    end

    it "should run the dev_tools recipe" do
      chef_run.should include_recipe 'ingenerator-php::dev_tools'
    end
  end

end
