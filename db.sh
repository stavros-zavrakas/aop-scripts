#!/bin/bash

# Selecting the correct database to drop, according to  
# the NODE_ENV variable.
# development = aop-product-dev
# staging = aop-product-staging
# production = aop-product

DB_NAME='aop-product-dev'
if [ -n "$NODE_ENV" ] ; then
  if [ "$NODE_ENV" = "staging" ] ; then
    DB_NAME='aop-product-staging'
  elif [ "$NODE_ENV" = "production" ] ; then
    DB_NAME='aop-product'
  fi
fi

mongo $DB_NAME --eval "db.dropDatabase()"
grunt --base "$PRODUCT_MODULES_PATH/aop-migrations" --gruntfile "$PRODUCT_MODULES_PATH/aop-migrations/Gruntfile.js" migrations:up --module=aop-core