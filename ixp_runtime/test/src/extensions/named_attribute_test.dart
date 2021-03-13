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

// @dart=2.10

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
}
