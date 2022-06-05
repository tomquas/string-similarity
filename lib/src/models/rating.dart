/// Dice's Coefficient result
class Rating {
  Rating({
    required this.rating,
    required this.index,
     this.target,
  });

  /// reference text
  String? target;
  /// between 0 and 1. 0 indicates completely different strings, 1 indicates identical strings.
  double rating;
  // reference to index in list
  int index;

  @override
  String toString() => '\'$target\'[$rating]';
}