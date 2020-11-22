import 'package:runtime/annotations.dart';

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

  Registration(this.person, this.contact, this.age);
}

@tag('note')
class Note {
  final NoteText text;

  Note(this.text);

  @override
  bool operator ==(Object other) => other is Note && other.text == text;

  @override
  int get hashCode => 12345 ^ (text ?? '').hashCode;
}

@tag('t')
class NoteText {
  @textElement
  final String text;

  NoteText([this.text = '?']);

  @override
  bool operator ==(Object other) => other is NoteText && other.text == text;

  @override
  int get hashCode => 37 ^ (text ?? '').hashCode;
}

@tag('addressBook')
class AddressBook {
  final List<ContactInfo> contacts;

  AddressBook(this.contacts);
}

@tag('notebook')
class Notebook {
  final List<Note> notes;

  Notebook(this.notes);
}
