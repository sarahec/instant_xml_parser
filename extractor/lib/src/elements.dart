import 'package:runtime/annotations.dart';

@tag('w:document')
class Document {
  final Body body;

  Document(this.body);
}

@tag('w:body')
class Body {
  final List<Paragraph> paragraphs;

  Body(this.paragraphs);
}

@tag('w:p')
class Paragraph {
  final List<TextRun> textRuns;

  Paragraph(this.textRuns);
}

@tag('w:r')
class TextRun {
  final List<Text> segments;

  TextRun(this.segments);
}

class Text {
  @text()
  final String value;

  Text(this.value);
}
