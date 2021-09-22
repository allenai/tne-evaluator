#!/bin/bash

set -e

# This script will build the TNE evaluator Docker image, and publish a Beaker
# image as the Leaderboard user. This is meant to be referenced when making a
# Jetty app to evaluate TNE Leaderboard submissions.
#
# To run this script, you'll need the Beaker CLI to be authenticated as the
# Leaderboard user (us_s03ci03mnt6u). If you have a config file for this user
# with the secret token, set the BEAKER_CONFIG_FILE env var to point to it. For
# example:
#
# BEAKER_CONFIG_FILE=/Users/michalg/.beaker/config-leaderboard.yml

echo ------------------------------------
echo Confirming Beaker identity
echo ------------------------------------

BEAKER_USER=$(beaker account whoami --format json | jq -r '.[0].id')

if [ "$BEAKER_USER" != "us_s03ci03mnt6u" ]; then
    echo "Incorrect beaker user. Expecting leaderboard user, but got this instead: $BEAKER_USER"
    exit 1
fi

echo "Leaderboard identity confirmed."
echo

echo ------------------------------------
echo Building image locally
echo ------------------------------------

IMAGE_NAME="tne-evaluator-$(date -u +%Y%m%d-%H%M%S)-utc"

docker build -t $IMAGE_NAME .
echo

echo ------------------------------------
echo Publishing image to Beaker
echo ------------------------------------

beaker image create --name $IMAGE_NAME --workspace leaderboard/private $IMAGE_NAME
echo

echo ------------------------------------
echo Finished
echo ------------------------------------
echo
echo Here is the image:

beaker image get leaderboard/$IMAGE_NAME

