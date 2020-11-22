import 'package:async/async.dart';
import 'package:runtime/runtime.dart';
import 'package:test/test.dart';
import 'package:xml/xml_events.dart';

void main() {
  // this needs an explicit type to enable the extension methods
  StreamQueue<XmlEvent> events;

  String getID(element) => element.attributes
      .firstWhere((a) => a.qualifiedName == 'id', orElse: () => null)
      ?.text;

  setUp(() {
    final xml =
        '<!-- test --><foo><in id="1"/><in id="2"/></foo><bar /><p id="1">Hello,</p><p id="2"> World</p>';
    events = generateEventStream(Stream.value(xml));
  });

  group('constraints', () {
    test('named', () async {
      final XmlStartElementEvent tag = await events.find(named('p'));
      expect(tag.name, equals('p'));
      expect(getID(tag), equals('1'));
    });

    test('inside', () async {
      final foo = await events.find(named('foo'));
      final in1 = await events.find(inside(foo));
      await events.next;
      final in2 = await events.find(inside(foo));
      await events.next;
      final end = await events.find(inside(foo));
      expect(in1, isNotNull);
      expect(in2, isNot(same(in1)));
      expect(end, isNull);
    });
  });
}
