#!/bin/bash
# 
# Wrapper script for running any CLI command with the environment variables required to start an
# xdebug debugger session for the lifetime of the current script execution. This script is written
# out by chef with the appropriate idekey and serverName configuration.
#
# Usage: xdebug {script_name} {script_args}
#
# Author: Andrew Coulton <andrew@ingenerator.com>
# Copyright: 2012-13 inGenerator Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Catch incorrect usage
echo "Args:"
for var in "$@"
do
  echo "$var"
done
echo ""
env