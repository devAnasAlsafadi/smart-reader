class ExtractDigitsUseCase {
  List<String> call(String text) {
    final cleaned = text.replaceAll(RegExp(r'[^0-9\s]'), ' ');

    final matches = RegExp(r'\d+').allMatches(cleaned);

    final digits = matches
        .map((e) => e.group(0)!)
        .where((e) => e.length >= 4)
        .toList();

    return digits;
  }
}