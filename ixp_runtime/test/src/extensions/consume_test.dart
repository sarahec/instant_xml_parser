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
import 'package:ixp_runtime/ixp_runtime.dart';
import 'package:test/test.dart';
import 'package:xml/src/xml_events/utils/named.dart';
import 'package:xml/xml_events.dart';

void main() {
  test('named', () async {
    final events = generateEventStream(Stream.value('<empty /><foo/>'));
    await events.consume(named('empty'));
    final probe = await events.next as XmlNamed;
    expect(probe.qualifiedName, equals('foo'));
  });

  test('inside', () async {
    final events = generateEventStream(
        Stream.value('<foo><in id="1"/><in id="2"/></foo><bar />'));
    final foo = await events.next as XmlStartElementEvent;
    await events.consume(inside(foo));
    final probe = await events.next as XmlNamed;
    expect(probe.qualifiedName, equals('bar'));
  });
}
