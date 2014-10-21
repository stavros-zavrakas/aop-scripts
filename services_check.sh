#!/bin/bash

echo "-----------------------------------"
echo "Checking the running services"
echo "-----------------------------------"
SERVICES_RUNNING=(mongod redis-server)
for SERVICE in "${SERVICES_RUNNING[@]}"; do
  is_running=$(ps aux | grep $SERVICE | wc -l)
  if [ "$is_running" -gt 0 ] ; then
    echo "$SERVICE is running"
  else
    echo "$SERVICE not running. Exiting."
    exit 1
  fi
done

echo "-----------------------------------"
echo "Checking the installed software"
echo "-----------------------------------"
SERVICES_INSTALLED=(svn node npm grunt bower sass)
for SERVICE in "${SERVICES_INSTALLED[@]}"; do
  command -v $SERVICE >/dev/null 2>&1 || { echo >&2 "$SERVICE is required but it's not installed. Aborting."; exit 1; }
  echo "$SERVICE is installed"
done
