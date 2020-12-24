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
