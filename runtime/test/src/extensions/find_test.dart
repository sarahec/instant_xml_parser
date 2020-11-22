import 'package:async/async.dart';
import 'package:runtime/runtime.dart';
import 'package:test/test.dart';
import 'package:xml/xml_events.dart';

void main() {
  // this needs an explicit type to enable the extension methods
  StreamQueue<XmlEvent> events;

  setUp(() {
    final xml =
        '<!-- test --><foo><in id="1"/><in id="2"/></foo><bar /><p id="1">Hello,</p><p id="2"> World</p>';
    events = generateEventStream(Stream.value(xml));
  });

  group('find', () {
    test('matching value', () async {
      final XmlStartElementEvent startTag =
          await events.find((e) => e is XmlStartElementEvent);
      expect(startTag.qualifiedName, equals('foo'));
    });

    test('drops found vaue by default', () async {
      final XmlStartElementEvent startTag =
          await events.find((e) => e is XmlStartElementEvent);
      final XmlStartElementEvent duplicateTag =
          await events.find((e) => e is XmlStartElementEvent);
      expect(duplicateTag, isNot(same(startTag)));
    });

    test('keepFound retains result', () async {
      final XmlStartElementEvent startTag =
          await events.find((e) => e is XmlStartElementEvent, keepFound: true);
      expect(await events.peek, same(startTag));
    });

    test('returns null if no match', () async {
      final xml = '<!-- comment only -->';
      events = generateEventStream(Stream.value(xml));
      final tag = await events.find((e) => e is XmlStartElementEvent);
      expect(tag, isNull);
    });

    test('returns null if match throws', () async {
      final tag = await events.find((e) => throw NoSuchMethodError);
      expect(tag, isNull);
    });

    test('leaves queue unchanged on no match', () async {
      final xml = '<!-- comment only -->';
      events = generateEventStream(Stream.value(xml));
      final comment = await events.peek;
      final tag = await events.find((e) => e is XmlStartElementEvent);
      expect(tag, isNull);
      expect(comment, same(await events.peek));
    });
  });
}
