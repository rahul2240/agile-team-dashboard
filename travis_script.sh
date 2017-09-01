#!/bin/bash
# This script runs the test suites for the CI build

# Be verbose and fail script on the first error
set -xe

# By default: all test runs
if [ -z $1 ]; then
  TEST_SUITE="all"
else
  TEST_SUITE="$1"
fi

case $TEST_SUITE in
  linters)
    bundle exec rubocop -Dc .rubocop.yml
    bundle exec slim-lint .
    jshint .
    ;;
  rspec)
    bundle exec rspec --color
    ;;
  *)
    bundle exec rubocop -Dc .rubocop.yml
    jshint .
    bundle exec rspec --color
    ;;
esac
