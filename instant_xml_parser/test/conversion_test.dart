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

  String _stripNewlines(String s) => s.replaceAll(RegExp(r'\s\s+'), ' ');

  group('conversion', () {
    setUp(() async {
      generated = await g.generate('''
        import 'package:ixp_runtime/annotations.dart';

        @tag('loc')
        class Location {
          final String foo; // not in constructor, won't be parsed

          @textElement
          @convert('Uri.parse')
          final Uri loc;

          @convert('Uri.parse')
          final Uri altLoc;

          Location(this.loc, this.altLoc);
        }''');
    });

    test(
        'attribute',
        () => expect(generated,
            contains("optionalAttribute<Uri>('altLoc', convert: Uri.parse)")));

    test(
        '@text',
        () => expect(_stripNewlines(generated),
            contains('loc = Uri.parse((await events.peek as XmlTextEvent).text)')));
  });

  group('custom', () {
    setUp(() async {
      generated = await g.generate('''
        import 'package:ixp_runtime/annotations.dart';

        @tag('loc')
        class Location {
          @custom("'Hello, world'")
          final String foo; 

          final Uri altLoc;

          Location(this.foo, this.altLoc);
        }''');
    });

    test(
        'foo',
        () => expect(
            generated, contains("fooCompleter.complete('Hello, world')")));
  });

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

  group('children', () {
    setUp(() async {
      generated = await g.generate('''
        import 'package:ixp_runtime/annotations.dart';

        @tag('contact')
        class ContactInfo {
          final String email;
          final String phone;

          ContactInfo([this.email, this.phone]);
        }

        @tag('registration')
        class Registration {
          final NameTag person;
          final ContactInfo contact;
          final int age;

          Registration(this.person, {this.contact=ContactInfo(), this.age=99});
        }''');
    });

    test(
        'extracts child',
        () =>
            expect(generated, contains('contact = await extractContactInfo')));
    test('applies default',
        () => expect(generated, contains('var contact = ContactInfo();')));
  });

  group('imports', () {
    setUp(() async {
      generated = await g.generate('''
        import 'package:ixp_runtime/annotations.dart';
        import 'other.dart';

        @tag('contact')
        class ContactInfo {
          final String email;
          final String phone;

          ContactInfo([this.email, this.phone]);
        }''');
    });

    test('passes to generated code',
        () => expect(generated, contains("import 'other.dart';")));
  });
}
