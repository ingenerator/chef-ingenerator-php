name 'ingenerator-php'
maintainer 'Andrew Coulton'
maintainer_email 'andrew@ingenerator.com'
license 'Apache 2.0'
description 'Installs PHP with standard config and helpers for inGenerator projects'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'

%w(ubuntu).each do |os|
  supports os
end

depends 'composer'
# 1.7.0 introduces a breaking change regarding the quoting of attribute values - prevent updating
# past 1.6.x until we have implemented some wrapping/warning and/or introduced a breaking
# version of this cookbook to prevent unexpected production php config changes
depends 'php', '~>1.6.0'
