#!/bin/bash
set -e

source dev-container-features-test-lib

check "atuin can be executed" bash -c "atuin --version"

reportResults
