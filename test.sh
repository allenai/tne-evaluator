#!/bin/bash

set -e

export PYTHONPATH=.

echo
echo ----------------------------------
echo unit tests
echo ----------------------------------
echo

set -x

pytest

set +x

echo
echo ----------------------------------
echo testfiles-1
echo ----------------------------------
echo

set -x

python evaluate.py --predictions_file test_files/predictions1.jsonl --gold_file test_files/answers1.jsonl --output_file /tmp/metrics.json

if [ "$(cat /tmp/metrics.json)" != '{"labeled_p": 1.0, "labeled_r": 1.0, "labeled_f1": 1.0, "unlabeled_p": 1.0, "unlabeled_r": 1.0, "unlabeled_f1": 1.0}' ]; then
    echo File /tmp/metrics.json looks wrong.
    exit 1
fi

echo File /tmp/metrics.json looks okay.

set +x

echo
echo ----------------------------------
echo testfiles-2
echo ----------------------------------
echo

set -x

python evaluate.py --predictions_file test_files/predictions2.jsonl --gold_file test_files/answers2.jsonl --output_file /tmp/metrics.json

if [ "$(cat /tmp/metrics.json)" != '{"labeled_p": 0.5, "labeled_r": 0.3333333333333333, "labeled_f1": 0.4, "unlabeled_p": 1.0, "unlabeled_r": 0.6666666865348816, "unlabeled_f1": 0.800000011920929}' ]; then
    echo File /tmp/metrics.json looks wrong.
    exit 1
fi

echo File /tmp/metrics.json looks okay.

set +x

echo
echo ----------------------------------
echo testfiles-3
echo ----------------------------------
echo

set -x

python evaluate.py --predictions_file test_files/predictions3.jsonl --gold_file test_files/answers3.jsonl --output_file /tmp/metrics.json

if [ "$(cat /tmp/metrics.json)" != '{"labeled_p": 0.6, "labeled_r": 0.75, "labeled_f1": 0.6666666666666665, "unlabeled_p": 0.800000011920929, "unlabeled_r": 1.0, "unlabeled_f1": 0.888888955116272}' ]; then
    echo File /tmp/metrics.json looks wrong.
    exit 1
fi

set +x


echo
echo ----------------------------------
echo Docker
echo ----------------------------------
echo

set -x

./test-in-docker.sh