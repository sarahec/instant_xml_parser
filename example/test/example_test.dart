import 'package:async/async.dart';
import 'package:example/example.dart';
import 'package:test/test.dart';
import 'package:xml/xml_events.dart';

void main() {
  StreamQueue<XmlEvent> _eventsFrom(String xml) => StreamQueue(Stream.value(xml)
      .toXmlEvents()
      .withParentEvents()
      .normalizeEvents()
      .flatten());

  test('tag only', () async {
    var result = await emptyTag(_eventsFrom('<empty></empty>'));
    expect(result, isA<EmptyTag>());
  });

  test('self-closing tag only', () async {
    var result = await emptyTag(_eventsFrom('<empty />'));
    expect(result, isA<EmptyTag>());
  });
}
