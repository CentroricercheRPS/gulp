#!/bin/bash
set -e

# prepend gulp to any command
set -- gulp "$@"

npm install --save-dev

bower install --allow-root

gulp build

