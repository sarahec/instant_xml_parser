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
import 'package:xml/xml_events.dart';

void main() {
  test('inside', () async {
    final events = generateEventStream(Stream.value('<a><b/>hello</a><c/>'));
    final a = await events.peek as XmlStartElementEvent;
    final inA = inside(a);
    expect(inA(await events.next), isTrue); // <a>
    expect(inA(await events.next), isTrue); // <b/>
    expect(inA(await events.next), isTrue); // hello
    expect(inA(await events.next), isTrue); // </a>
    expect(inA(await events.next), isFalse); // <c/>
  });

  test('named', () async {
    final events =
        generateEventStream(Stream.value('<a /><b/><a:b></a:b><c>hello</c>'));
    final isB = named('a:b');
    expect(isB(await events.next), isFalse); // <a/>
    expect(isB(await events.next), isFalse); // <b/>
    expect(isB(await events.next), isTrue); // <a:b>
    expect(isB(await events.next), isTrue); // </a:b>
    expect(isB(await events.next), isFalse); // <c>
    expect(isB(await events.next), isFalse); // Hello
    expect(isB(await events.next), isFalse); // </c>
  });

  test('not', () async {
    final events =
        generateEventStream(Stream.value('<a /><b/><a:b /><c>hello</c>'));
    final none = not(named('a'));
    expect(none(await events.next), isFalse); // <a/>
    expect(none(await events.next), isTrue); // <b/>
  });

  test('startTag', () async {
    final events = generateEventStream(Stream.value('<a /><b /><c>hello</c>'));
    final isStart = startTag();
    expect(isStart(await events.next), isTrue); // <a/>
    expect(isStart(await events.next), isTrue); // <b/>
    expect(isStart(await events.next), isTrue); // <c>
    expect(isStart(await events.next), isFalse); // Hello
    expect(isStart(await events.next), isFalse); // </c>
  });

  test('textElement', () async {
    final events = generateEventStream(Stream.value('<c>hello</c>'));
    final isText = textElement();
    expect(isText(await events.next), isFalse); // <c>
    expect(isText(await events.next), isTrue); // Hello
    expect(isText(await events.next), isFalse); // </c>
  });

  test('valid textElement inside(x)', () async {
    final events = generateEventStream(Stream.value('<c>hello</c>'));
    await events.scanTo(startTag(named('c')));
    final tag = await events.peek as XmlStartElementEvent;
    final foundText = await events.scanTo(textElement(inside(tag)));
    expect(foundText, isTrue);
  });

  test('missing textElement inside(x)', () async {
    final events = generateEventStream(Stream.value('<c></c>'));
    await events.scanTo(startTag(named('c')));
    final tag = await events.peek as XmlStartElementEvent;
    final foundText = await events.scanTo(textElement(inside(tag)));
    expect(foundText, isFalse);
  });
}
