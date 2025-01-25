String extractLocationId(String url) {
  final regex = RegExp(r'/location/(\d+)$');
  final match = regex.firstMatch(url);
  return match?.group(1) ?? '';
}