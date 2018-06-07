#!/bin/bash
set -ex

export PATH="$HOME/dart-sdk/bin:$PATH"
export ROOT="$PWD"

if [[ "$SHARD" == "dartfmt" ]]; then
  dartfmt --dry-run --set-exit-if-changed packages || exit $?
elif [[ "$SHARD" == "analyze" ]]; then
  for package in "${PACKAGES[@]}"; do
    echo "Analyzing package "
    cd $ROOT/packages
    dartanalyzer --options=$ROOT/analysis_options.yaml . || exit $?
  done
else
  # tests shard
  cd $ROOT/package
  flutter --no-color test --machine --start-paused test/infinity_page_view_test.dart || exit $?
fi
