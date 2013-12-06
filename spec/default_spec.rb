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

end
