#!/bin/bash

set -e

LAST_RELEASE_TAG=${1:-$(git rev-list --max-parents=0 HEAD)} # Default to the initial commit hash if no tag is found

# Find changed packages since the last release
CHANGED_PACKAGES=$(git diff --name-only "$LAST_RELEASE_TAG" HEAD -- packages | cut -d/ -f2 | uniq)

for PACKAGE in $CHANGED_PACKAGES; do
  PACKAGE_PATH="packages/$PACKAGE"

  if [ -d "$PACKAGE_PATH" ]; then
    echo "Publishing package: $PACKAGE ($PACKAGE_PATH)"

    wally publish --project-path $PACKAGE_PATH
  else
    echo "Skipping: $PACKAGE_PATH does not exist"
  fi
done
