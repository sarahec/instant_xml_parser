import 'package:docx_extractor/docx_extractor.dart';
import 'package:test/test.dart';
import 'package:xml/xml_events.dart';

void main() {
  final helloXML = '''
        <w:p>
            <w:r>
                <w:t>Hello, World</w:t>
            </w:r>
        </w:p>''';
  final splitHelloXML = '''
        <w:p>
            <w:r>
                <w:t>Hello,</w:t>
                <w:t>World</w:t>
            </w:r>
        </w:p>''';
  final multiRunHello = '''
        <w:p>
            <w:r>
                <w:t>Hello,</w:t>
                <w:t>World</w:t>
            </w:r>
        </w:p>''';
  final helloXMLWithSpace = '''
        <w:p>
            <w:r>
                <w:t>Hello, World </w:t>
            </w:r>
        </w:p>''';
  final helloXMLWithPreservedSpace = '''
        <w:p>
            <w:r>
                <w:t xml:space="preserve">Hello, World </w:t>
            </w:r>
        </w:p>''';

  group('extract text run', () {
    Parser parser;

    setUp(() {
      parser = Parser();
    });

    test('single', () async {
      var stream = parser.generateEventStream(xml: helloXML);
      var result = await parser.extractTextRun(stream.flatten());
      expect(result.text, equals('Hello, World'));
    });

    test('two-part', () async {
      var stream = parser.generateEventStream(xml: splitHelloXML);
      var result = await parser.extractTextRun(stream.flatten());
      expect(result.text, equals('Hello, World'));
    });

    test('trims whitespace', () async {
      var stream = parser.generateEventStream(xml: helloXMLWithSpace);
      var result = await parser.extractTextRun(stream.flatten());
      expect(result.text, equals('Hello, World'));
    });

    test('preserves whitespace', () async {
      var stream = parser.generateEventStream(xml: helloXMLWithPreservedSpace);
      var result = await parser.extractTextRun(stream.flatten());
      expect(result.text, equals('Hello, World '));
    });
  });
}
