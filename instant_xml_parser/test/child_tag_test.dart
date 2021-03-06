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
}
