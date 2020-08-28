import 'package:xml/xml_events.dart';

void main() {
  final docXML = '''<w:document>
    <w:body>
        <w:p>
            <w:r>
                <w:t>Hello, World</w:t>
            </w:r>
        </w:p>
    </w:body>
</w:document>''';

  Stream.value(docXML)
      .toXmlEvents()
      .selectSubtreeEvents((event) => event.localName == 'body')
      .forEach((event) => print(event));
}
