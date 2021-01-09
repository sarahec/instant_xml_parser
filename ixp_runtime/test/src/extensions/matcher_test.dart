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

import 'get_id.dart';

void main() {
  // this needs an explicit type to enable the extension methods
  StreamQueue<XmlEvent> events;
  final xml =
      '<!-- test --><foo><in id="1"/><in id="2"/></foo><bar /><p id="1">Hello,</p><p id="2"> World</p>';
  group('constraints', () {
    test('named', () async {
      events = generateEventStream(Stream.value(xml));
      final tag = await events.find(named('p')) as XmlStartElementEvent;
      expect(tag.name, equals('p'));
      expect(getID(tag), equals('1'));
    });

    test('inside', () async {
      events = generateEventStream(Stream.value(xml));
      final foo = await events.find(named('foo')) as XmlStartElementEvent;
      final in1 = await events.find(inside(foo)) as XmlStartElementEvent;
      await events.next;
      final in2 = await events.find(inside(foo)) as XmlStartElementEvent;
      await events.next;
      final end = await events.find(inside(foo)) as XmlStartElementEvent;
      expect(in1, isNotNull);
      expect(in2, isNot(same(in1)));
      expect(end, isNull);
    });
  });
}
