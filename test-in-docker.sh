#!/bin/bash

set -euo pipefail

echo
echo --------------------------------
echo Building image
echo --------------------------------
echo

set -x

docker build -t tne-evaluator-local .

set +x

echo
echo --------------------------------
echo Running
echo --------------------------------
echo

set -x

T=$(mktemp -d /tmp/tmp-XXXXX)


docker run \
 -v $PWD/test_files:/test_files:ro \
 -v $T:/output:rw \
 -it --rm --entrypoint python \
 tne-evaluator-local \
 evaluate.py \
 --predictions_file /test_files/predictions3.jsonl \
 --gold_file /test_files/answers3.jsonl \
 --output_file /output/test_metrics.json

if [ "$(cat $T/test_metrics.json)" != '{"labeled_p": 0.6, "labeled_r": 0.75, "labeled_f1": 0.6666666666666665, "unlabeled_p": 0.800000011920929, "unlabeled_r": 1.0, "unlabeled_f1": 0.888888955116272}' ]; then
    echo File $T/metrics.json looks wrong.
    exit 1
fi

echo $T/metrics.json looks okay.

set +x