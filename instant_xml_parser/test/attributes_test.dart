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

void main() {
  final g = WrappedGenerator();
  var generated;

  group('attributes', () {
    setUp(() async {
      generated = await g.generate('''
        import 'package:ixp_runtime/annotations.dart';

        @tag('identification')
        class NameTag {
          final String name;
          final int id;
          final double score;
          final bool registered;

          NameTag(this.name, this.registered, {this.id=0});
        }''');
    });

    test(
        'picks up tag name',
        () => expect(
            generated, contains("const NameTagName = 'identification'")));

    test('reads attributes', () {
      expect(generated, contains("_nameTag.optionalAttribute<String>('name')"));
      expect(
          generated, contains("_nameTag.optionalAttribute<int>('id') ?? 0;"));
      expect(generated,
          contains("_nameTag.optionalAttribute<bool>('registered')"));
    });

    test(
        'creates object with known fields',
        () => expect(
            generated, contains('return NameTag(name, registered, id: id)')));
  });
}
