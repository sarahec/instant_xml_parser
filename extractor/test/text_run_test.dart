import 'package:docx_extractor/docx_extractor.dart';
import 'package:runtime/runtime.dart';
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
  final helloXMLWithCR = '''
        <w:p>
            <w:r>
                <w:t>Hello, World</w:t>
                <w:cr />
                <w:t>How are you?</w:t>
            </w:r>
        </w:p>''';
  final helloXMLWithPreservedSpace = '''
        <w:p>
            <w:r>
                <w:t xml:space="preserve">Hello, World </w:t>
            </w:r>
        </w:p>''';

  final pr = ParserRuntime();

  group('extract text run', () {
    test('single', () async {
      final stream = generateEventStream(Stream.value(helloXML));
      final result = await extractParagraph(stream, pr);
      expect(result.toString(), equals('Hello, World'));
    });

    test('two-part', () async {
      final stream = generateEventStream(Stream.value(splitHelloXML));
      final result = await extractParagraph(stream, pr);
      expect(result.toString(), equals('Hello,World'));
    });

    test('trims whitespace', () async {
      final stream = generateEventStream(Stream.value(helloXMLWithSpace));
      final result = await extractParagraph(stream, pr);
      expect(result.toString(), equals('Hello, World'));
    });

    test('preserves whitespace', () async {
      final stream =
          generateEventStream(Stream.value(helloXMLWithPreservedSpace));
      final result = await extractParagraph(stream, pr);
      expect(result.toString(), equals('Hello, World '));
    });

    test('sees return character', () async {
      final stream = generateEventStream(Stream.value(helloXMLWithCR));
      final result = await extractParagraph(stream, pr);
      expect(result.toString(), equals('Hello, World\nHow are you?'));
    });
  });
}
