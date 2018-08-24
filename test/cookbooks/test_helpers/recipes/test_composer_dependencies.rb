composer_dependencies node['test']['project_dir'] do
  run_as              node['test']['run_as']
  check_platform_reqs node['test']['check_requirements'] unless node['test']['check_requirements'].nil?
end
