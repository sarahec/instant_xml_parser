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

  // TODO Add default value back in once ctor scanning works
  AttributesTag(this.name, this.temperature, this.active, [this.count = 0]);
}

@tag('identification')
class NameTag {
  final String name;

  NameTag(this.name);
}

@tag('ContactInfo')
class ContactInfo {
  final String email;
  final String phone;

  ContactInfo(this.email, this.phone);
}

@tag('registration')
class Registration {
  final NameTag person;
  final ContactInfo contact;
  final int age;

  Registration(this.person, this.contact, this.age);
}
