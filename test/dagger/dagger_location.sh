#!/bin/bash
set -e

source dev-container-features-test-lib

check "dagger is installed to a different location" bash -c "which dagger | grep '/usr/bin'"

reportResults
