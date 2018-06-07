#!/bin/bash
set -ex

export PATH=~/development/flutter/bin:$PATH
export ROOT="$PWD"

if [[ "$SHARD" == "dartfmt" ]]; then
 echo 'Formating code'
 cd $ROOT/package
 flutter format . || exit $?
else
  # tests shard
  cd $ROOT/package
  flutter --no-color test --machine --start-paused test/infinity_page_view_test.dart || exit $?
fi
