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
  final List<RunSegment> segments;

  TextRun(this.segments);

  /// Added for testing purposes, not required when generating a parser
  @override
  String toString() => segments?.join('') ?? 'null';
}

abstract class RunSegment {
  String get value;

  /// Added for testing purposes, not required when generating a parser
  @override
  String toString() => value ?? 'null';
}

@tag('w:t')
class TextSegment extends RunSegment {
  @alias('xml:space')
  final String space;

  @text()
  final String rawValue;

  TextSegment(this.space, this.rawValue);

  @override
  String get value =>
      space != null && space == 'preserve' ? rawValue : rawValue.trim();
}

@tag('w:br')
class Break extends RunSegment {
  @alias('w:type')
  final String breakType;

  @override
  String get value => '\n';

  Break(this.breakType);
}

@tag('w:cr')
class LineBreak extends RunSegment {
  @override
  String get value => '\n';
}

// Formatting

/*
@tag('w:b')
class Bold {
  @alias('w:val')
  @ifMatches(r'(on|1)')
  final bool enabled;

  Bold(this.enabled);
}
*/
