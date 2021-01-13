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
import 'package:ixp_runtime/annotations.dart';

@tag('empty')
class EmptyTag {
  EmptyTag();
}

@tag('attributesTest')
class AttributesTag {
  final String name;
  final int count;
  final double temperature;
  final bool active;

  AttributesTag(this.name, this.temperature, this.active, [this.count = 0]);
}

@tag('identification')
class NameTag {
  final String name;
  @textElement
  final String nickname;

  NameTag(this.name, {this.nickname});
}

@tag('ContactInfo')
class ContactInfo {
  final String email;
  final String phone;
  @textElement
  final String notes;

  // You can add getters and methods.
  // The unit tests for the parser require == on this class
  @override
  bool operator ==(Object other) =>
      other is ContactInfo &&
      other.email == email &&
      other.phone == phone &&
      other.notes == notes;

  // ...and if you override ==, override hashCode.
  @override
  int get hashCode =>
      email.hashCode ^ (phone ?? 'none').hashCode ^ notes.hashCode;

  ContactInfo(this.email, {this.phone, this.notes = ''});
}

@tag('registration')
class Registration {
  final NameTag person;
  final ContactInfo contact;
  final int age;

  Registration(this.person, this.contact, [this.age]);
}

@tag('note')
class Note {
  @textElement
  final String text;

  Note(this.text);

  @override
  bool operator ==(Object other) => other is Note && other.text == text;

  @override
  int get hashCode => 12345 ^ text.hashCode;
}

@tag('notebook')
class Notebook {
  final List<Note> notes;

  Notebook(this.notes);
}

@tag('addressBook')
class AddressBook {
  final List<ContactInfo> contacts;

  AddressBook(this.contacts);
}
