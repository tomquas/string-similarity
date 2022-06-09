import 'rating.dart';

/// Dice's Coefficient results
class BestMatch<T> {
  BestMatch({
    required this.ratings,
    required this.bestMatch,
  });

  /// similarity rating for each target string
  List<Rating<T>> ratings;

  /// specifies which target string was most similar to the main string
  Rating<T> bestMatch;

  List<Rating<T>> sort() {
    ratings.sort((r1, r2) => r2.rating.compareTo(r1.rating)); // descending
    return ratings;
  }

  @override
  String toString() => bestMatch.toString();
}