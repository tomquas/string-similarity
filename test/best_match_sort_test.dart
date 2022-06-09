import 'package:string_similarity/string_similarity.dart';
import 'package:test/test.dart';

class TestData {
  TestData({this.sentenceA, this.sentenceB, required this.expected});

  String? sentenceA;
  String? sentenceB;
  double expected;
}

void main() {
  late List<TestData> _testData;

  group('sort', () {
    setUp(() {
      _testData = <TestData>[
        TestData(sentenceA: 'mailed', expected: 0.4),
        TestData(sentenceA: 'edward', expected: 0.2),
        TestData(sentenceA: 'sealed', expected: 0.8),
        TestData(sentenceA: 'theatre', expected: 0.36363636363636365),
      ];
    });

    test('sorts all ratings', () {
      final matches = StringSimilarity.findBestMatch('healed', _testData, (td) => (td as TestData).sentenceA);
      final sorted = matches.ratings;

      for (var i = 0; i < sorted.length - 1; i++) {
        expect(sorted[i].rating, greaterThanOrEqualTo(sorted[i+1].rating));
      }
    });
  });
}
