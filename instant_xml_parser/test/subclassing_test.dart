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

  group('subclassing', () {
    setUp(() async {
      generated = await g.generate('''
        import 'package:ixp_runtime/annotations.dart';

        abstract class Foo {
          final String name;

          Foo(this.name);
        }

        @tag('bar')
        class Bar extends Foo {
          Bar(name) : super(name);
        }''');
    });

    test(
        'collects superclass field',
        () => expect(
            generated,
            contains(
                "final name = await _bar.optionalAttribute<String>('name');")));
  });
}
