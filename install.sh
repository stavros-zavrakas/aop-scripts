#!/bin/bash

# Check always if the scripts are valid here:
# http://www.shellcheck.net

if [ "$EUID" -eq 0 ]
  then echo "Please don't run this script as root!"
  exit
fi

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
REPOSITORIES_PATH="$( cd $SCRIPT_PATH/../../.. && pwd )"
export LOG_FILE="$SCRIPT_PATH/log.txt"
export PRODUCT_MODULES_PATH="$REPOSITORIES_PATH/aop-product/aop-product/node_modules"
export SVN_MODULES_PATH="$REPOSITORIES_PATH/aop-modules"
PRODUCT_BOWER_PATH="$REPOSITORIES_PATH/aop-product/aop-product/templates/system/public/aop-ui-framework"

if [ -n "$1" ] && [ "$1" = "modules" ] ; then
  source "$SCRIPT_PATH//modules.sh"
elif [ -n "$1" ] && [ "$1" = "database" ] ; then
  source "$SCRIPT_PATH/db.sh"
else
  if [ -z "$1" ] ; then
    echo "Please provide as first argument your username"
    exit 1
  fi
  
  source "$SCRIPT_PATH/services_check.sh"

  echo "-----------------------------------"
  echo "Cloning the modules repository"
  echo "-----------------------------------"
  (rm -rf "$SVN_MODULES_PATH"; cd "$REPOSITORIES_PATH"; svn checkout https://scm.aop.cambridge.org/svn/aop-modules/trunk aop-modules --username "$1" >> "$LOG_FILE")

  echo "Running npm install.."
  rm -rf "$PRODUCT_MODULES_PATH"
  (npm install >> "$LOG_FILE")

  echo "Scanning the node_modules.."
  source "$SCRIPT_PATH/modules.sh"

  echo "Running bower install.."
  (rm -rf "$PRODUCT_BOWER_PATH/bower_components"; cd "$PRODUCT_BOWER_PATH"; bower install >> "$LOG_FILE")
fi