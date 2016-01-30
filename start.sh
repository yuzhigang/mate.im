#! /bin/sh
PORT=4001 MIX_ENV=prod elixir --name mate@localhost --cookie mate \
 --detached -S mix do compile, phoenix.server
