import 'package:runtime/annotations.dart';

@tag('w:document')
class Document {
  final Body body;

  Document(this.body);

  @override
  String toString() => body ?? '';
}

@tag('w:body')
class Body {
  final List<Paragraph> paragraphs;

  Body(this.paragraphs);

  /// Added for testing purposes, not required when generating a parser
  @override
  String toString() => paragraphs?.join('\n\n') ?? '';
}

@tag('w:p')
class Paragraph {
  final List<TextRun> textRuns;

  Paragraph(this.textRuns);

  /// Added for testing purposes, not required when generating a parser
  @override
  String toString() => textRuns?.join('') ?? '';
}

@tag('w:r')
class TextRun {
  final List<Text> segments;

  TextRun(this.segments);

  /// Added for testing purposes, not required when generating a parser
  @override
  String toString() => segments?.join('') ?? 'null';
}

@tag('w:t')
class Text {
  @text('msOffice')
  final String value;

  Text(this.value);

  /// Added for testing purposes, not required when generating a parser
  @override
  String toString() => value ?? 'null';
}
