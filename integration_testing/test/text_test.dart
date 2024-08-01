import 'package:integration_testing/text.dart';
import 'package:integration_testing/text.parser.dart';
import 'package:ixp_runtime/ixp_runtime.dart';
import 'package:test/test.dart';

// Copyright 2021, 2024 Google LLC and contributors
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

void main() {
  test('collects attribute', () async {
    final events = generateEventStream(
        Stream.value('<identification name="Robert"></identification>'));
    final nameTag = await extractNameTag(events);
    expect(nameTag, isA<NameTag>());
    expect(nameTag.name, equals('Robert'));
  });

  test('collects optional body text', () async {
    final events = generateEventStream(
        Stream.value('<identification name="Robert">Bob</identification>'));
    final nameTag = await extractNameTag(events);
    expect(nameTag.nickname, equals('Bob'));
  });

  test('collects required body text', () async {
    final events = generateEventStream(
        Stream.value('<extended name="Robert">Bob</extended>'));
    final nameTag = await extractExtendedNameTag(events);
    expect(nameTag.name, equals('Robert'));
    expect(nameTag.nickname, equals('Bob'));
  });

  test('ignores missing body text for nullable field', () async {
    final events = generateEventStream(
        Stream.value('<identification name="Robert"></identification>'));
    final nameTag = await extractNameTag(events);
    expect(nameTag.name, equals('Robert'));
  });

  test(
      'throws on missing body text for required field',
      () async => expect(
          extractExtendedNameTag(
              generateEventStream(Stream.value('<extended name="Robert" />'))),
          throwsA(const TypeMatcher<MissingText>())));
}
