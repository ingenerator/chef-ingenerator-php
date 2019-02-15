# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/). Note that
0.x versions may be breaking, per the semver standard.

## Unreleased

* [BREAKING] Update share_env_inis paths to /etc/php/7.2/... per ubuntu package
  locations - will throw if the project still specifies any at /etc/php5
* [BREAKING] Expect to install php7.2
* [BREAKING] drop chef12 support
* [BREAKING] update to the latest php cookbook (drops mysql dep, some pear related
  recipes) and apparently adds initial 18.04 support 

## 2.1.0 (2018-08-24)

* Bump build-time dependencies
* Run composer check-platform-reqs before installing dependencies by default - you 
  can disable this by setting the resource option if absolutely necessary but it 
  would be better to fix either the packages you're installing or the runtime 
  environment.

## 2.0.1 (2017-08-10)

* Exclude unnecessary build-time files and dependencies from the vendored cookbook

## 2.0.0 (2017-08-09)

* [BUGFIX] Set :localdev xdebug configuration at attribute rather than recipe
  stage so that it is present in time to be rendered in the php.ini config file
* Move xdebug attributes for the CLI xdebug wrapper script to attributes instead
  of recipe level
* [POTENTIALLY BREAKING] update to version 4.5 of the php cookbook - primarily
  internal changes on our supported platforms.
* [BUGFIX] don't modify node attribute string in composer resource (causes frozen
  string error in chef 13).
* Update build dependencies and build against Chef 12 and Chef 13

## 1.0.0 (2017-02-24)

* Add `composer_dependencies` resource to provision dependencies, by default
  optimising the autoloader and enabling APCU autoloader unless in local dev.
  This resource needs to be triggered manually in your own code. It DOES NOT
  manually set the composer home directory any more.
* [BREAKING] Drop dependency on zircote/chef-composer and provide an updated
  `composer_binary` resource for installing composer on a node using the
  default composer-setup script now provided by composer. Will now throw an
  exception if the legacy `composer[install_path]` attribute is still defined.
* [BREAKING] Always display errors in development and buildslave, hide in
  production. Log errors to syslog by default.
* Automatically enables revalidating opcode cache file timestamps in dev, but
  never revalidates in production. Removes apc file-caching options.
* Change to defining individual default directives / attributes instead of as a
  complete hash - this prevents the defaults here from splatting any that are
  defined in other cookbooks earlier in the run. This is potentially breaking,
  but only in that the old behaviour was buggy and wrong and doesn't seem to have
  bitten us yet.
* [BREAKING] Update to php cookbook 2.2. This no longer quotes values in php.ini
  by default : you will need to manually add quotes to the attribute values in
  `node['php']['directives']`.
* Use ingenerator-helpers and `node_environment` instead of chef-sugar to trigger
  provisioning of xdebug remote debugging options


## 0.1.0 (2017-02-23)

* First tagged release
