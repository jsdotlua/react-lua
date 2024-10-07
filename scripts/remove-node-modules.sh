#!/bin/sh

set -e

FOLDER=$1

find $FOLDER -name 'node_modules' -type d -depth -exec rm -r {} +
