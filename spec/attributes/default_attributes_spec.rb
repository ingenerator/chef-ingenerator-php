require 'spec_helper'

describe 'ingenerator-php::default_attributes' do

  let (:chef_runner) { ChefSpec::SoloRunner.new }
  let (:chef_run)    { chef_runner.converge 'ingenerator-php::_noop' }

  before(:each) do
    allow_any_instance_of(Chef::Node).to receive(:node_environment).and_return(node_environment)
  end

  context 'in :localdev' do
    let (:node_environment) { :localdev }

    it 'revalidates opcache timestamps every pageload' do
      expect(default_php_directive('opcache.validate_timestamps')).to be(1)
      expect(default_php_directive('opcache.revalidate_freq')).to be(0)
    end
  end

  context 'in :buildslave' do
    let (:node_environment) { :buildslave }

    it 'never revalidates opcache timestamps' do
      expect(default_php_directive('opcache.validate_timestamps')).to be(0)
      expect(default_php_directive('opcache.revalidate_freq')).to be(:not_present)
    end

  end

  context 'outside localdev or buildslave' do
    let (:node_environment) { 'anything' }

    it 'never revalidates opcache timestamps' do
      expect(default_php_directive('opcache.validate_timestamps')).to be(0)
      expect(default_php_directive('opcache.revalidate_freq')).to be(:not_present)
    end
  end

  def default_php_directive(directive)
    chef_run.node.debug_value('php', 'directives', directive).to_h['default']
  end

end
