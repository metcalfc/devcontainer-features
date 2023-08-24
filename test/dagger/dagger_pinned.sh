#!/bin/bash
set -e

source dev-container-features-test-lib

check "dagger can be pinned to a specific version" bash -c "dagger version | grep 'v0.8.0'"

reportResults
