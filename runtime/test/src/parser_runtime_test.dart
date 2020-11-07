import 'package:runtime/runtime.dart';
import 'package:runtime/src/tools.dart';
import 'package:test/test.dart';
import 'package:xml/xml_events.dart';

void main() {
  group('runtime:', () {
    var pr;

    setUp(() => pr = ParserRuntime());
    group('startOf()', () {
      var events;

      setUp(() {
        final xml = '<foo /> <bar /> <p id="1"></p>';
        events = generateEventStream(Stream.value(xml));
      });

      test('finds start tag', () async {
        final startTag = await pr.startOf(events);
        expect(startTag, isA<XmlStartElementEvent>());
      });

      test('finds named start tag', () async {
        final startTag = await pr.startOf(events, name: 'p');
        expect(startTag, isA<XmlStartElementEvent>());
        expect(startTag.name, equals('p'));
      });

      test('remains on start tag', () async {
        final startTag = await pr.startOf(events);
        final duplicateTag = await pr.startOf(events);
        expect(duplicateTag, same(startTag));
      });

      test('truncates to start tag', () async {
        await pr.startOf(events, name: 'p');
        expect(
            events,
            emitsInOrder([
              isA<XmlStartElementEvent>(),
              isA<XmlEndElementEvent>(),
              emitsDone
            ]));
      });

      test('accepts self-closing tag', () async {
        final startTag = await pr.startOf(events, name: 'foo');
        expect((startTag as XmlStartElementEvent).isSelfClosing, isTrue);
      });

      test('returns null if no match', () async {
        final startTag = await pr.startOf(events, name: 'q');
        expect(startTag, isNull);
      });
    });

    group('startOf() inside parent', () {
      var events;

      setUp(() {
        final xml = '''
        <doc>
          <par id="p1">
            <c id="c1p1">
              <gc id="gc1" />
            </c>
          </par>
          <par id="p2">
            <c id="c1p2">
              <gc id="gc1p2" />
            </c>
            <c id="c2p2" />;
          </par>
        </doc>''';

        events = generateEventStream(Stream.value(xml));
      });

      test('finds first child', () async {
        final startTag =
            await pr.startOf(events, name: 'c') as XmlStartElementEvent;
        expect(startTag.name, equals('c'));
        final idAttr = getID(startTag);
        expect(idAttr, equals('c1p1'));
        expect(startTag.parentEvent, isNotNull);
      });

      test('finds next from nested', () async {
        // final doc = await pr.startOf(events);
        final gc1 = await pr.startOf(events, name: 'gc');
        // confirm we have the correct child
        final gc1id = getID(gc1);
        expect(gc1id, equals('gc1'));
        // now the test: p2 should be next
        events.skip(1);
        final p2 = await pr.startOf(events);
        final p2id = getID(p2);
        expect(p2id, equals('p2'));
      });

      test('returns null on no match', () async {
        final ancestor = await pr.startOf(events, name: 'par');
        final gc = await pr.startOf(events, name: 'gc');
        // precondition: we're in the right place
        expect(getID(gc), equals('gc1'));
        await events.skip(1);
        var probe = await pr.startOf(events, ancestor: ancestor);
        expect(probe, isNull);
      });
    });
  });
}

String getID(element) => element.attributes
    .firstWhere((a) => a.qualifiedName == 'id', orElse: () => null)
    ?.value;
