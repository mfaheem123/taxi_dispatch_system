
extension StringExtension on String {
  String maxLength(int maxChars) {
    if (this.length <= maxChars) return this;
    return '${this.substring(0, maxChars)}...';
  }
}