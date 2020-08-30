mixin DocElement {
  static String qualifiedName;
  String get tag;
}

class TextRun with DocElement {
  static String qualifiedName = 'w:r';
  final String text;

  @override
  final String tag = 'tr';

  TextRun(this.text);
}
