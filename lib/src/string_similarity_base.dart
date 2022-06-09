import 'models/best_match.dart';
import 'models/rating.dart';

typedef SearchIndex<T> = String? Function(T?);

// ignore: avoid_classes_with_only_static_members
/// Finds degree of similarity between two strings, based on Dice's Coefficient, which is mostly better than Levenshtein distance.
class StringSimilarity {
  /// Returns a fraction between 0 and 1, which indicates the degree of similarity between the two strings. 0 indicates completely different strings, 1 indicates identical strings. The comparison is case-sensitive.
  ///
  /// _(same as 'string'.similarityTo extension method)_
  ///
  /// ##### Arguments
  /// - first (String?): The first string
  /// - second (String?): The second string
  ///
  /// (Order does not make a difference)
  ///
  /// ##### Returns
  /// (number): A fraction from 0 to 1, both inclusive. Higher number indicates more similarity.
  static double compareStrings(String? first, String? second) {
    // if both are null
    if(first == null && second == null){
      return 1;
    }
    // as both are not null if one of them is null then return 0
    if(first == null || second == null){
      return 0;
    }

    // remove all whitespace, convert to lower case for better results
    // on mixed case strings
    final noWhitespaceRE = RegExp(r'\s+\b|\b\s');
    first = first.replaceAll(noWhitespaceRE, '');
    second = second.replaceAll(noWhitespaceRE, '');

    // if both are empty strings
    if (first.isEmpty && second.isEmpty) {
      return 1;
    }
    // if only one is empty string
    if (first.isEmpty || second.isEmpty) {
      return 0;
    }
    // identical
    if (first == second) {
      return 1;
    }
    // both are 1-letter strings
    if (first.length == 1 && second.length == 1) {
      return 0;
    }
    // if either is a 1-letter string
    if (first.length < 2 || second.length < 2) {
      return 0;
    }

    final firstBigrams = <String, int>{};
    for (var i = 0; i < first.length - 1; i++) {
      final bigram = first.substring(i, i + 2);
      final count = firstBigrams.containsKey(bigram) ? firstBigrams[bigram]! + 1 : 1;
      firstBigrams[bigram] = count;
    }

    var intersectionSize = 0;
    for (var i = 0; i < second.length - 1; i++) {
      final bigram = second.substring(i, i + 2);
      final count = firstBigrams.containsKey(bigram) ? firstBigrams[bigram]! : 0;

      if (count > 0) {
        firstBigrams[bigram] = count - 1;
        intersectionSize++;
      }
    }

    return (2.0 * intersectionSize) / (first.length + second.length - 2);
  }

  /// Compares term against each string in targetStrings
  ///
  /// _(same as 'string'.bestMatch extension method)_
  ///
  /// ##### Arguments
  /// - term (String?): The string to match each target string against.
  /// - targetStrings (List<String?>): Each string in this array will be matched against the main string.
  /// - threshold (double): min rating to make it on the list
  ///
  /// ##### Returns
  /// (BestMatch): An object with a ratings property, which gives a similarity rating for each target string, a bestMatch property, which specifies which target string was most similar to the main string, and a bestMatchIndex property, which specifies the index of the bestMatch in the targetStrings array.
  static BestMatch<T> findBestMatch<T>(String? term, List<T?> objects, SearchIndex<T>? extract, {
    double threshold = 0.0,
    bool sortRatings = true,
  }) {
    final ratings = <Rating<T>>[];
    Rating<T>? hit;

    for (var i = 0; i < objects.length; i++) {
      final ref = objects[i];
      final searchable = extract != null ? extract(ref) : ref as String?;
      final diceCoeff = compareStrings(term, searchable);
      if (diceCoeff >= threshold) {
        // target is includude only for debugging purposes; clients should
        // use ref to access the reference object
        final rating = Rating(target: searchable, rating: diceCoeff, ref: ref);
        ratings.add(rating);

        // do we have a new highscore?
        hit = hit ?? rating;
        if (diceCoeff > hit.rating) {
          hit = rating;
        }
      }
    }

    final result = BestMatch<T>(ratings: ratings, bestMatch: hit!);
    if (sortRatings) {
      result.sort();
    }
    return result;
  }

  static List<Rating<T>> sortRatings<T>(BestMatch<T> bm) {
    return bm.sort();
  }
}
