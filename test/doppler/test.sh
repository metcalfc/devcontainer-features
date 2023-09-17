#!/bin/bash
set -e

source dev-container-features-test-lib



check "doppler can be executed" bash -c "doppler --version"

reportResults
