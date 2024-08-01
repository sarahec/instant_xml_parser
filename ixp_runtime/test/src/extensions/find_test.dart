// Copyright 2020, 2024 Google LLC and contributors
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
import 'package:ixp_runtime/ixp_runtime.dart';
import 'package:test/test.dart';
import 'package:xml/xml_events.dart';

void main() {
  // this needs an explicit type to enable the extension methods
  StreamQueue<XmlEvent> events;
  final xml =
      '<!-- test --><foo><in id="1"/><in id="2"/></foo><bar /><p id="1">Hello,</p><p id="2"> World</p>';

  group('scanTo', () {
    test('finds next matching value', () async {
      events = generateEventStream(Stream.value(xml));
      final found = await events.scanTo((e) => e is XmlStartElementEvent);
      expect(found, isTrue);
      final startTag = await events.next as XmlStartElementEvent;
      expect(startTag.qualifiedName, equals('foo'));
    });

    test('returns false if no match', () async {
      final xml = '<!-- comment only -->';
      events = generateEventStream(Stream.value(xml));
      final found = await events.scanTo((e) => e is XmlStartElementEvent);
      expect(found, isFalse);
    });

    test('returns false if match throws', () async {
      events = generateEventStream(Stream.value(xml));
      final found = await events.scanTo(((e) => throw NoSuchMethodError));
      expect(found, isFalse);
    });

    test('leaves queue unchanged on no match', () async {
      final xml = '<!-- comment only -->';
      events = generateEventStream(Stream.value(xml));
      final comment = await events.peek;
      final found = await events.scanTo((e) => e is XmlStartElementEvent);
      expect(found, isFalse);
      expect(comment, same(await events.peek));
    });
  });
}
