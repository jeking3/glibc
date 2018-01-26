#! /bin/bash

set -ex

# tell the build script NOT to run the tests or install
export COVERITY_BUILD=1

cov-build --dir cov-int /develop/ci/build/build.sh
tar cJf cov-int.tar.xz cov-int/
curl --form token="$COVERITY_SCAN_TOKEN" \
     --form email="$COVERITY_SCAN_NOTIFICATION_EMAIL" \
     --form file=@cov-int.tar.xz \
     --form version="$(git describe --tags)" \
     --form description="$ACCT/$SELF" \
     https://scan.coverity.com/builds?project=GNU+C+Library+-+glibc"

