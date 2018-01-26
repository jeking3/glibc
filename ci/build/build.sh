#! /bin/bash

#
# /develop holds our sources
# /install will hold our installation prefix
# /stage will hold our build environment
#

set -ex

mkdir /stage
mkdir /install
cd /stage
/develop/configure --prefix=/install

# The build is very noisy - we don't want to break the 4MB log limit
# and every item compiled is a huge command line, so we hide them and the noisy library archiver
make V=0 -j3 | grep -v 'gcc ' | grep -v 'g++ ' | grep -v 'a - ' | grep -v 'echo ' | grep -v 'env GCONV_PATH='
rc=${PIPESTATUS[0]}
if [[ $rc -ne 0 ]]; then
  echo Build failed.
  exit $rc
fi

if [[ "$COVERITY_BUILD" == "" ]]; then
  make check   | grep -v 'gcc ' | grep -v 'g++ ' | grep -v 'a - ' | grep -v 'echo' | grep -v 'env GCONV_PATH='
  rc=${PIPESTATUS[0]}
  if [[ $rc -ne 0 ]]; then
    echo Test failed.
    exit $rc
  fi

  make install | grep -v 'gcc ' | grep -v 'g++ ' | grep -v 'a - ' | grep -v 'echo' | grep -v 'env GCONV_PATH='
  rc=${PIPESTATUS[0]}
  if [[ $rc -ne 0 ]]; then
    echo Install failed.
    exit $rc
  fi
fi

