import 'rating.dart';

/// Dice's Coefficient results
class BestMatch {
  BestMatch({required this.ratings, required this.bestMatch});

  /// similarity rating for each target string
  List<Rating> ratings;

  /// specifies which target string was most similar to the main string
  Rating bestMatch;

  /// index of the best matchin the targetStrings array
  int get bestMatchIndex => bestMatch.index;

  @override
  String toString() => bestMatch.toString();
}