import 'dart:io';

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
  final List<TextSegment> segments;

  TextRun(this.segments);

  /// Added for testing purposes, not required when generating a parser
  @override
  String toString() => segments?.join('') ?? 'null';
}

abstract class Text {
  String get value;

  /// Added for testing purposes, not required when generating a parser
  @override
  String toString() => value ?? 'null';
}

@tag('w:t')
class TextSegment extends Text {
  @alias('xml:space')
  final String space;

  @text()
  final String rawValue;

  TextSegment(this.space, this.rawValue);

  @override
  String get value =>
      space != null && space == 'preserve' ? rawValue : rawValue.trim();
}

@tag('w:cr')
class CR extends Text {
  @override
  String get value => '\n';
}
