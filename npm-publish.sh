#!/bin/bash

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MODULES_PATH="$SCRIPT_PATH/aop-modules"

npm set registry http://host/
npm set always-auth true
npm adduser

for module_name in $(ls "$MODULES_PATH" | egrep 'aop-' | awk '{print $1}') ; do
  read -p "Do you want to publish '$module_name'? " yn
  case $yn in
    [Yy]* ) 
      vim "$SCRIPT_PATH/aop-modules/$module_name/src/package.json"
      echo "We are publishing '$module_name'"
      (cd "$SCRIPT_PATH/aop-modules/$module_name/src"; npm pack; npm publish)
      # (cd "$SCRIPT_PATH/aop-modules/$module_name/src"; npm pack; npm publish)
      ;;
    * ) 
      echo "We are not publishing '$module_name'.";;
  esac
done

