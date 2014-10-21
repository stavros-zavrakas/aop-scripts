#!/bin/bash
echo "Scanning the node_modules.."
# "ls -l $PRODUCT_MODULES_PATH"       = get all the modules list
# "| egrep '^d'"                      = pipe to egrep and select only the aop modules
# "awk '{print $1}'"                  = pipe the result from egrep to awk and print only the 9th field that is the name

# and now loop through the directories:
for module_name in $(ls "$SVN_MODULES_PATH" | egrep 'aop-' | awk '{print $1}') ; do
  echo -e "Removing module and creating symlink for module '$module_name'"
  rm -fr "${PRODUCT_MODULES_PATH}/$module_name"
  if [ "$module_name" = "aop-migrations" ] ; then
    cp -R "${SVN_MODULES_PATH}/$module_name/src" "${PRODUCT_MODULES_PATH}/$module_name"
    (cd "${PRODUCT_MODULES_PATH}/$module_name" && npm install >> "$LOG_FILE")
  else
    ln -s "${SVN_MODULES_PATH}/$module_name/src" "${PRODUCT_MODULES_PATH}/$module_name"
  fi
done

