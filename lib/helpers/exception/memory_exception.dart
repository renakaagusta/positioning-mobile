class MemoryException implements Exception {
  final String message;

  MemoryException(this.message);

  @override
  String toString() {
    return message;
  }
}