/**
 * Copyright 2021 Google LLC
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

import 'package:ixp_runtime/ixp_runtime.dart';
import 'package:test/test.dart';

void main() {
  test('ancestors', () async {
    final events = generateEventStream(Stream.value('<a><b><c/></b></a>'));
    final a = await events.next;
    final b = await events.next;
    final c = await events.next;
    final end_b = await events.next;
    final end_a = await events.next;

    expect(a.ancestors, isEmpty);
    expect(b.ancestors, containsAll([a]));
    expect(c.ancestors, containsAll([a, b]));
    expect(end_b.ancestors, containsAll([a, b]));
    expect(end_a.ancestors, containsAll([a]));
  });

  test('descendsFrom', () async {
    final events = generateEventStream(Stream.value('<a><b><c/></b></a>'));
    final a = await events.next;
    final b = await events.next;
    final end_b = await events.next;
    final end_a = await events.next;

    expect(a.descendsFrom(a), isFalse);
    expect(a.descendsFrom(b), isFalse);
    expect(b.descendsFrom(a), isTrue);
    expect(end_b.descendsFrom(a), isTrue);
    expect(end_a.descendsFrom(a), isTrue);
  });
}
