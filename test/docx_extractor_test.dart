import 'package:docx_extractor/docx_extractor.dart';
import 'package:test/test.dart';
import 'package:xml/xml_events.dart';

void main() {
  group('Text runs', () {
    final docXML = '''<w:document>
    <w:body>
        <w:p>
            <w:r>
                <w:t>Hello, World</w:t>
            </w:r>
        </w:p>
    </w:body>
</w:document>''';

    Parser parser;

    setUp(() {
      parser = Parser();
    });

    test('Extract text run', () async {
      var stream = parser.generateEventStream(xml: docXML);
      var result = await parser.extractTextRun(stream
          .selectSubtreeEvents((e) => e.name == TextRun.qualifiedName)
          .flatten());
      expect(result.text, equals('Hello, World'));
    });
  });
}
