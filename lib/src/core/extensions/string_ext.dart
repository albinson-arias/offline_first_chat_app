extension StringExt on String {
  String removeNewLines() {
    return replaceAll('\n', ' ').replaceAll('\r', ' ');
  }
}
