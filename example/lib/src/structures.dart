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
  @text()
  final String nickname;

  NameTag(this.name, {this.nickname});
}

@tag('ContactInfo')
class ContactInfo {
  final String email;
  final String phone;

  // You can add getters and methods.
  // The unit tests for the parser require == on this class
  @override
  bool operator ==(Object other) =>
      other is ContactInfo && other.email == email && other.phone == phone;

  // ...and if you override ==, override hashCode.
  @override
  int get hashCode => email.hashCode ^ (phone ?? 'none').hashCode;

  ContactInfo(this.email, [this.phone]);
}

@tag('registration')
class Registration {
  final NameTag person;
  final ContactInfo contact;
  final int age;

  Registration(this.person, this.contact, this.age);
}

@tag('addressBook')
class AddressBook {
  final List<ContactInfo> contacts;

  AddressBook(this.contacts);
}
