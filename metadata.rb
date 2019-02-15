name 'ingenerator-php'
maintainer 'Andrew Coulton'
maintainer_email 'andrew@ingenerator.com'
license 'Apache-2.0'
chef_version '>=13.12.1'
description 'Installs PHP with standard config and helpers for inGenerator projects'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url 'https://github.com/ingenerator/chef-ingenerator-php/issues'
source_url 'https://github.com/ingenerator/chef-ingenerator-php'
version '3.0.0'

%w(ubuntu).each do |os|
  supports os
end

depends 'ingenerator-helpers', '~> 1.0'
depends 'php', '~> 6.1'
