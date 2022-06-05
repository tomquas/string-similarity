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
      final matches = StringSimilarity.findBestMatch('healed', _testData.map((TestData testEntry) => testEntry.sentenceA).toList());

      for (var i = 0; i < matches.ratings.length; i++) {
        expect(_testData[i].sentenceA, matches.ratings[i].target);
        expect(_testData[i].expected, matches.ratings[i].rating);
      }
    });

    test('returns the best match and its similarity rating', () {
      final matches = StringSimilarity.findBestMatch('healed', _testData.map((TestData testEntry) => testEntry.sentenceA).toList());

      expect(matches.bestMatch.target, 'sealed');
      expect(matches.bestMatch.rating, 0.8);
    });

    test('returns the index of best match from the target strings', () {
      final matches = StringSimilarity.findBestMatch('healed', _testData.map((TestData testEntry) => testEntry.sentenceA).toList());

      expect(matches.bestMatchIndex, 2);
    });

    test('bestMatch extensions method return same result that StringSimilarity.findBestMatch', () {
      const mainString = 'healed';
      final targetStrings = _testData.map((TestData testEntry) => testEntry.sentenceA).toList();
      final a = StringSimilarity.findBestMatch(mainString, targetStrings);
      final b = mainString.bestMatch(targetStrings);

      expect(a.toString(), b.toString());
    });

    test('bestMatch extensions method can be call on null anonymous variable', () {
      final a = null.bestMatch([null]);
      final b = null.bestMatch(['a']);

      expect(a.bestMatch.rating, 1);
      expect(b.bestMatch.rating, 0);
    });
  });
}
