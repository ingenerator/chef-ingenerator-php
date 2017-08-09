inGenerator Standard PHP cookbook
=================================
[![Build Status](https://travis-ci.org/ingenerator/chef-ingenerator-php.png?branch=2.x)](https://travis-ci.org/ingenerator/chef-ingenerator-php)

`ingenerator-php` provides standard PHP configuration and related tooling for our applications using Chef.

Requirements
------------
- Chef 12.18 or higher
- **Ruby 2.3 or higher**

Installation
------------
We recommend adding to your `Berksfile` and using [Berkshelf](http://berkshelf.com/):

```ruby
source 'https://chef-supermarket.ingenerator.com'
cookbook 'ingenerator-php', '~>2.0'
```

Have your main project cookbook *depend* on ingenerator-php by editing the `metadata.rb` for your cookbook.

```ruby
# metadata.rb
depends 'ingenerator-php'
```

Usage
-----

For the simplest cases, add the default recipe to your `run_list`:

```ruby
# In a role
"run_list" : [
  "recipe[ingenerator-php::default]"
]

# In a recipe - note your cookbook must declare a dependency in metadata.rb as above
include_recipe "ingenerator-php::default"
```

The default recipe executes the following steps:

| Recipe      | Action                                                                                              |
|-------------|-----------------------------------------------------------------------------------------------------|
| install_php | Installs php and any additional modules                                                             |
| share_inis  | Configures php to share ini files between apache, cgi and cli                                       |
| composer    | Installs and updates composer globally for all users                                                |

To customise behaviour, include any or all of these recipes directly rather than relying on the default.

Resources
---------

### `composer_binary`

Used by the `composer` recipe to install and update the composer executable

### `composer_dependencies`

Use this resource in your project-specific recipes to run composer install against a project's composer.json. It
requires a composer.lock to be present, and will fail if this is missing. By default this will optimise the
autoloader and activate apcu caching, unless running in the :localdev environment. Customise this behaviour
with node attributes for now (though will in due course be added as resource options).

```ruby
composer_dependencies path_to_project_root_dir do
  run_as 'any-user-except-root'
end
```

Attributes
----------

The cookbook defines a number of attributes for php.ini settings that we set differently to
the Ubuntu package defaults. See [the attributes files](attributes/) for details. You can
override these or add further directives in your own cookbooks or roles.

### Testing
See the [.travis.yml](.travis.yml) file for the current test scripts.

Contributing
------------
1. Fork the project
2. Create a feature branch corresponding to your change
3. Create specs for your change
4. Create your changes
4. Create a Pull Request on github

License & Authors
-----------------
- Author:: Andrew Coulton (andrew@ingenerator.com)

```text
Copyright 2012-2013, inGenerator Ltd

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
