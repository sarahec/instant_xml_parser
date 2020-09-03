mixin DocElement {
  static String qualifiedName;
}

class Paragraph with DocElement {
  static String qualifiedName = 'w:p';
  final List<TextRun> textRuns;

  Paragraph(this.textRuns);
}

class TextRun with DocElement {
  static String qualifiedName = 'w:r';
  final String text;

  TextRun(this.text);
}
