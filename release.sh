#!/bin/sh
rm -rf ./priv/static/*
MIX_ENV=prod mix compile
#brunch build --production
brunch build
MIX_ENV=prod mix phoenix.digest
find ./priv/static -name *.js.map -exec rm  {} \;
find ./priv/static -name *.css.map -exec rm  {} \;