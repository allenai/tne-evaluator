import argparse
import json


def load_data(in_f):
    with open(in_f, 'r') as f:
        data = f.readlines()

    data = [json.loads(x.strip()) for x in data]
    return data


def dump_data(docs, out_f):
    with open(out_f, 'w') as f:
        for doc in docs:
            json.dump(doc, f)
            f.write('\n')


def data_conversion(doc):

    dic = {
        'predicted_prepositions': doc['predicted_prepositions'],
    }

    return dic


def main():
    parse = argparse.ArgumentParser("")
    parse.add_argument("--input", type=str, help="input data file", default="train")
    parse.add_argument("--output", type=str, help="output file where the converted values will be written",
                       default="train")

    args = parse.parse_args()

    print('=== Reading input file ===')

    document_answers = load_data(args.input)

    print('=== Converting... ===')
    minimal_labels = [data_conversion(x) for x in document_answers]

    print('=== Writing results to file ===')
    dump_data(minimal_labels, args.output)

    print('=== Done ===')


if __name__ == '__main__':
    main()
