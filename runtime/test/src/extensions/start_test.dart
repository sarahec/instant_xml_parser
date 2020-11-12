import 'package:async/async.dart';
import 'package:runtime/runtime.dart';
import 'package:test/test.dart';
import 'package:xml/xml_events.dart';

void main() {
  // this needs an explicit type to enable the extension methods
  StreamQueue<XmlEvent> events;

  setUp(() {
    final xml = '<foo /> <bar /> <p id="1"></p>';
    events = generateEventStream(Stream.value(xml));
  });

  test('finds start tag', () async {
    final startTag = await events.start();
    expect(startTag, isA<XmlStartElementEvent>());
  });

  test('remains on start tag', () async {
    final startTag = await events.start();
    final duplicateTag = await events.start();
    expect(duplicateTag, same(startTag));
  });

  test('accepts self-closing tag', () async {
    final startTag = await events.start();
    expect(startTag.isSelfClosing, isTrue);
  });

  test('validates tag name', () async {
    final startTag = await events.start(name: 'foo');
    expect(startTag, isA<XmlStartElementEvent>());
    expect(startTag.name, equals('foo'));
  });

  test('scans to matching tag', () async {
    final startTag = await events.start(name: 'bar');
    expect(startTag, isA<XmlStartElementEvent>());
    expect(startTag.name, equals('bar'));
  });

  test('scans past specified start', () async {
    final tag1 = await events.start();
    // since this returns the first start found, it will stay on the same start tag
    final tag1b = await events.start();
    // unless something consumes the previous start or asks to skip it
    final tag2 = await events.start(after: tag1);
    expect(tag1, same(tag1b));
    expect(tag2, isNot(same(tag1b)));
  });

  test('returns null if no match', () async {
    final xml = '<!-- comment only -->';
    events = generateEventStream(Stream.value(xml));
    final startTag = await events.start();
    expect(startTag, isNull);
  });

  test('throws error on no match if requested', () async {
    final xml = '<!-- comment only -->';
    events = generateEventStream(Stream.value(xml));
    expect(events.start(throwsOnError: true),
        throwsA(TypeMatcher<MissingStartTag>()));
  });
}

String getID(element) => element.attributes
    .firstWhere((a) => a.qualifiedName == 'id', orElse: () => null)
    ?.value;
