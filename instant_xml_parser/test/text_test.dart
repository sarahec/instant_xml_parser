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
import 'package:test/test.dart';

import 'common/wrapped_generator.dart';

String _stripNewlines(String s) => s.replaceAll(RegExp(r'\s\s+'), ' ');

void main() {
  final g = WrappedGenerator();
  var generated;

  group('text', () {
    setUp(() async {
      generated = await g.generate('''
        import 'package:ixp_runtime/annotations.dart';

        @tag('text')
        class NameTag {
          @textElement
          final String name;

          NameTag({this.name='sam'});
        }''');
    });

    test(
        'extracts text',
        () => expect(generated,
            contains('(await events.scanTo(textElement(inside(_nameTag))))')));

    test(
        'applies default',
        () => expect(
            _stripNewlines(generated),
            contains('if (await events.scanTo(textElement(inside(_nameTag)))) '
                '{ name = (await events.peek as XmlTextEvent).text; } '
                "else { name = 'sam'; }")));

    test('uses named parameter in constructor',
        () => expect(generated, contains('return NameTag(name: name);')));
  });
}
