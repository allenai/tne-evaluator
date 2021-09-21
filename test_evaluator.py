import os

from bridging.leaderboard import evaluate
import unittest
import tempfile
import typing


class TestAccuracy(unittest.TestCase):
    def test_EverythingCorrect(self):
        y = [
            {
                'prepositions': [[0], [1], [2], [3], [4]],
                'links': [0, 1, 1, 1, 1],
            }
        ]

        yh = [
            {
                'predicted_prepositions': [0, 1, 2, 3, 4],
                'best_prepositions': [1, 1, 2, 3, 4]
            }
        ]
        res = evaluate.evaluate_documents(y, yh)

        self.assertEqual(1.0, res['Labeled-p'])
        self.assertEqual(1.0, res['Labeled-r'])
        self.assertEqual(1.0, res['Labeled-f1'])

    def test_EverythingWrong(self):
        y = [
            {
                'prepositions': [[0], [1], [2], [3], [4]],
                'links': [0, 1, 1, 1, 1],
            }
        ]

        yh = [
            {
                'predicted_prepositions': [1, 0, 0, 0, 0],
                'best_prepositions': [1, 2, 3, 4, 5]
            }
        ]

        res = evaluate.evaluate_documents(y, yh)

        self.assertEqual(0.0, res['Labeled-p'])
        self.assertEqual(0.0, res['Labeled-r'])
        self.assertEqual(0.0, res['Labeled-f1'])

    def test_MixedResults(self):
        y = [
            {
                'prepositions': [[0], [1], [2], [3], [4]],
                'links': [0, 1, 1, 1, 1],
            }
        ]

        yh = [
            {
                'predicted_prepositions': [1, 0, 1, 3, 1],
                'best_prepositions': [1, 2, 3, 4, 5]
            }
        ]

        res = evaluate.evaluate_documents(y, yh)

        self.assertEqual(0.25, res['Labeled-p'])
        self.assertEqual(0.25, res['Labeled-r'])
        self.assertEqual(0.25, res['Labeled-f1'])


def temp_file_with_contents(lines: typing.List[str]) -> str:
    t = tempfile.NamedTemporaryFile(mode='wt', delete=False)
    t.writelines(lines)
    t.close()
    return t.name


class TestReadAnswers(unittest.TestCase):
    def test_ReadAnswers(self):
        t = temp_file_with_contents([
            '{"id": 1, "prepositions": [[0], [1]], "predicted_prepositions": [-1, 1]}\n',
            '{"id": 2, "prepositions": [[0], [1, 2]], "predicted_prepositions": [0, 1]}\n',
        ])
        answers = evaluate.load_data(t)
        os.remove(t)

        self.assertEqual(answers,
                         [
                             {'id': 1,
                              'prepositions': [[0], [1]],
                              'predicted_prepositions': [-1, 1]
                              },
                             {
                                 'id': 2,
                                 'prepositions': [[0], [1, 2]],
                                 'predicted_prepositions': [0, 1]
                             }
                         ])


if __name__ == '__main__':
    unittest.main()
