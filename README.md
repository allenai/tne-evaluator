# NPRED Evaluator

This script evaluates predictions for the NP RElation Discovery dataset
 against correct answers and produces multiple scores.

## Example

```bash
% python3 evaluate.py \\
          --predictions_file predictions.jsonl \\ 
          --gold_file test.jsonl \\
          --output_file metrics.json

% cat metrics.json
{"links-p": 0.5, "links-r": 0.5, "link-f1": 0.5, "identified_prep_acc": 0.9, "non_identified_prep_acc": 0.3, "micro-f1": 0.4}
```

## Usage

The script takes two input files and produces one output file.

### Input predictions

A prediction file has the document ids, index of the predicted relation (0 is for no-relation) in a JSONL format.
For example:

```bash
% cat predictions.csv
{'prepositions': [[0], [1], [2], [3], [4]], 'links': [0, 1, 1, 1, 1]}
{'prepositions': [[0], [1], [2], [3], [4]], 'links': [0, 1, 2, 3, 4]}
```
(Other attributes will be ignored)

### Input answers

A predictions file that has predictions in JSONL format. For example:


```bash
% cat questions.jsonl
{"id": 1, 'links': [-1, 0, 1, -1], 'prepositions': [1, 1, 2, 3, 4]}
{"id": 2, 'links': [-1, 0, 1, 1, -1, 0, 0, 1, -1], 'prepositions': [[0], [0], [2, 3], [4, 2], [0], [0], [0], [1], [0]}}
```


### Output metrics

A JSON file that has the different metrics we use in the range 0.0 to 1.0. For example:

```bash
% cat metrics.json 
{"labeled_p": 0.5, "labeled_r": 0.5, "labeled_f1": 0.5, "unlabeled_p": 0.9, "unlabeled_r": 0.3, "unlabeled_f1": 0.4}
```
* The results here are invented, and do not represent the scoring functions

## Development

### Unit tests

Run unit tests with `python3 test_evaluator.py`.

### Docker

Ultimately this evaluator is run in a Docker container. To test that it works there, run `test.sh`.

## Publishing

To build and publish a Beaker image as the Leaderboard user, use the script
`publish_for_leaderboard.sh`.
