/// Dice's Coefficient result
class Rating<T> {
  Rating({
    required this.rating,
    this.ref,
    this.target,
  });

  /// reference text
  String? target;
  /// between 0 and 1. 0 indicates completely different strings, 1 indicates identical strings.
  double rating;
  // reference to original object
  T? ref;

  @override
  String toString() => "'$target'[$rating]";
}