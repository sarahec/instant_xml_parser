// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
import 'package:async/async.dart';
import 'package:ixp_runtime/runtime.dart';
import 'package:test/test.dart';
import 'package:xml/xml_events.dart';

void main() {
  // this needs an explicit type to enable the extension methods
  StreamQueue<XmlEvent> events;
  final xml =
      '<!-- test --><foo><in id="1"/><in id="2"/></foo><bar /><p id="1">Hello,</p><p id="2"> World</p>';

  group('find', () {
    test('matching value', () async {
      events = generateEventStream(Stream.value(xml));
      final startTag = await events.find((e) => e is XmlStartElementEvent)
          as XmlStartElementEvent;
      expect(startTag.qualifiedName, equals('foo'));
    });

    test('drops found vaue by default', () async {
      events = generateEventStream(Stream.value(xml));
      final startTag = await events.find((e) => e is XmlStartElementEvent)
          as XmlStartElementEvent;
      final duplicateTag = await events.find((e) => e is XmlStartElementEvent)
          as XmlStartElementEvent;
      expect(duplicateTag, isNot(same(startTag)));
    });

    test('keepFound retains result', () async {
      events = generateEventStream(Stream.value(xml));
      final startTag = await events.find((e) => e is XmlStartElementEvent,
          keepFound: true) as XmlStartElementEvent;
      expect(await events.peek, same(startTag));
    });

    test('returns null if no match', () async {
      final xml = '<!-- comment only -->';
      events = generateEventStream(Stream.value(xml));
      final tag = await events.find((e) => e is XmlStartElementEvent);
      expect(tag, isNull);
    });

    test('returns null if match throws', () async {
      events = generateEventStream(Stream.value(xml));
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
