/// Extension for common operations on num
extension NumExtension on num {
  /// True if the number is between [min] and [max]
  bool isBetween(num min, num max) => this >= min && this <= max;
}
