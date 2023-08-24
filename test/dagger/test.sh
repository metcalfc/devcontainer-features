#!/bin/bash
set -e

source dev-container-features-test-lib

check "dagger can be executed" bash -c "dagger version"

reportResults
