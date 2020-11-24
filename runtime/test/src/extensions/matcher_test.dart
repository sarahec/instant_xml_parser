/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import 'package:async/async.dart';
import 'package:runtime/runtime.dart';
import 'package:test/test.dart';
import 'package:xml/xml_events.dart';

import 'get_id.dart';

void main() {
  // this needs an explicit type to enable the extension methods
  StreamQueue<XmlEvent> events;

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
