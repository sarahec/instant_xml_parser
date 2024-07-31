import 'package:ixp_runtime/ixp_runtime.dart';
import 'package:test/test.dart';
import 'package:xml/xml_events.dart';

void main() {
  test('hasAttribute', () async {
    final events = generateEventStream(Stream.value('<a id="1"/>'));
    final a = await events.next as XmlStartElementEvent;
    expect(await a.hasAttribute('id'), isTrue);
    expect(await a.hasAttribute('xyzzy'), isFalse);
  });

  test('attribute (raw)', () async {
    final events = generateEventStream(Stream.value('<a id="1"/>'));
    final a = await events.next as XmlStartElementEvent;
    expect(await a.attribute('id'), equals('1'));
  });

  test('auto-parsed', () async {
    final events = generateEventStream(Stream.value('<a id="1"/>'));
    final a = await events.next as XmlStartElementEvent;
    expect(await a.attribute<int>('id'), equals(1));
  });

  test('custom parser', () async {
    final events = generateEventStream(Stream.value('<a id="1"/>'));
    final a = await events.next as XmlStartElementEvent;
    expect(await a.attribute('id', convert: (s) => 'FOO'), equals('FOO'));
  });

  test('optional value', () async {
    final events = generateEventStream(Stream.value('<a id="1" bar="hi"/>'));
    final a = await events.next as XmlStartElementEvent;
    expect(await a.optionalAttribute('bar'), equals('hi'));
  });

  test('fallback value', () async {
    final events = generateEventStream(Stream.value('<a id="1" />'));
    final a = await events.next as XmlStartElementEvent;
    expect(await a.optionalAttribute('bar', fallback: 'hi'), equals('hi'));
  });
}
