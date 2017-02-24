require 'spec_helper'

describe 'ingenerator-php::composer' do
  let (:chef_runner) { ChefSpec::SoloRunner.new }
  let (:chef_run) { chef_runner.converge(described_recipe) }

  %w(install_path global_cache).each do |attr|
    it 'throws if composer.'+attr+' is still defined' do
      chef_runner.node.default['composer'][attr] = 'oops'
      expect { chef_run }.to raise_error Ingenerator::Helpers::Attributes::LegacyAttributeDefinitionError
    end
  end

  it "installs composer as a global binary" do
    expect(chef_run).to install_composer_binary('/usr/local/bin/composer')
  end

  it "updates to the most recent composer if required" do
    expect(chef_run).to update_composer_binary('/usr/local/bin/composer')
  end
end
