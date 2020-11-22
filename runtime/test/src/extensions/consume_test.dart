import 'package:async/async.dart';
import 'package:runtime/runtime.dart';
import 'package:test/test.dart';
import 'package:xml/xml_events.dart';

void main() {
  // this needs an explicit type to enable the extension methods
  StreamQueue<XmlEvent> events;

  String getID(element) => element.attributes
      .firstWhere((a) => a.qualifiedName == 'id', orElse: () => null)
      ?.value;

  setUp(() {
    final xml = '<empty /><foo><in id="1"/><in id="2"/></foo><bar />';
    events = generateEventStream(Stream.value(xml));
  });

  test('in mid-child', () async {
    final foo = await events.find(startTag(named('foo')));
    final in1 = await events.find(startTag(inside(foo)));
    expect(getID(in1), equals('1')); // precondition
    expect(await events.hasNext, isTrue); // precondition
    await events.consume(inside(foo));
    final bar = events.find(named('bar'));
    expect(bar, isNotNull);
  });

  test('self-closing', () async {
    final tag = await events.find(startTag(named('empty')));
    await events.consume(inside(tag));
    final foo = await events.find(startTag(named('foo')));
    expect(foo, isNotNull);
  });

  test('end tag', () async {
    final xml = '<a><b /></a><c />';
    events = generateEventStream(Stream.value(xml));
    final tag = await events.find(startTag(named('a')));
    await events.consume(inside(tag));
    final foo = await events.find((e) => e is XmlStartElementEvent)
        as XmlStartElementEvent;
    expect(foo?.qualifiedName, equals('c'));
  });
}
