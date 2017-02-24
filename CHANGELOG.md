# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/). Note that
0.x versions may be breaking, per the semver standard.

## Unreleased

* [BREAKING] Update to php cookbook 2.2. This no longer quotes values in php.ini
  by default : you will need to manually add quotes to the attribute values in
  `node['php']['directives']`.
* Use ingenerator-helpers and `node_environment` instead of chef-sugar to trigger
  provisioning of xdebug remote debugging options


## 0.1.0 (2017-02-23)

* First tagged release
