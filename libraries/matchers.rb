if defined?(ChefSpec)

  def install_composer_binary(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:composer_binary, :install, resource_name)
  end

  def update_composer_binary(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:composer_binary, :update, resource_name)
  end

end
