import 'package:docx_extractor/docx_extractor.dart';
import 'package:test/test.dart';

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
      final stream = parser.generateEventStream(Stream.value(helloXML));
      final result = await parser.extractParagraph(stream);
      expect(result.toString(), equals('Hello, World'));
    });

    test('two-part', () async {
      final stream = parser.generateEventStream(Stream.value(splitHelloXML));
      final result = await parser.extractParagraph(stream);
      expect(result.toString(), equals('Hello,World'));
    });

    test('trims whitespace', () async {
      final stream =
          parser.generateEventStream(Stream.value(helloXMLWithSpace));
      final result = await parser.extractParagraph(stream);
      expect(result.toString(), equals('Hello, World'));
    });

    test('preserves whitespace', () async {
      final stream =
          parser.generateEventStream(Stream.value(helloXMLWithPreservedSpace));
      final result = await parser.extractParagraph(stream);
      expect(result.toString(), equals('Hello, World '));
    });
  });
}
