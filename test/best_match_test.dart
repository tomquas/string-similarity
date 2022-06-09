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

  group('findBestMatch', () {
    setUp(() {
      _testData = <TestData>[
        TestData(sentenceA: 'mailed', expected: 0.4),
        TestData(sentenceA: 'edward', expected: 0.2),
        TestData(sentenceA: 'sealed', expected: 0.8),
        TestData(sentenceA: 'theatre', expected: 0.36363636363636365),
      ];
    });

    test('assigns a similarity rating to each string passed in the array', () {
      final matches = StringSimilarity.findBestMatch('healed',
        _testData.map((TestData testEntry) => testEntry.sentenceA).toList(),
        null,
        sortRatings: false);

      for (var i = 0; i < matches.ratings.length; i++) {
        expect(_testData[i].sentenceA, matches.ratings[i].target);
        expect(_testData[i].expected, matches.ratings[i].rating);
      }
    });

    test('returns the best match and its similarity rating', () {
      final matches = StringSimilarity.findBestMatch('healed',
      _testData.map((TestData testEntry) => testEntry.sentenceA).toList(),
      null);
      expect(matches.bestMatch.target, 'sealed');
      expect(matches.bestMatch.rating, 0.8);
    });

    test('returns only ratings gte threshold', () {
      final matches = StringSimilarity.findBestMatch('healed',
        _testData.map((TestData testEntry) => testEntry.sentenceA).toList(),
        null,
        threshold: 0.4,
        sortRatings: false);

      expect(matches.ratings.length, 2);
      expect(matches.ratings[0].target, _testData[0].sentenceA);
      expect(matches.ratings[1].target, _testData[2].sentenceA);
    });

    test('extension returns same result that StringSimilarity.findBestMatch', () {
      const query = 'healed';
      final targetStrings = _testData.map((TestData testEntry) => testEntry.sentenceA).toList();
      final a = StringSimilarity.findBestMatch(query, targetStrings, null);
      final b = query.bestMatch(targetStrings, null);
      expect(a.toString(), b.toString());
    });

    test('bestMatch extensions method can be call on null anonymous variable', () {
      expect(null.bestMatch([null], null).bestMatch.rating, 1);
      expect(null.bestMatch(['a'], null).bestMatch.rating, 0);
    });
  });
}
