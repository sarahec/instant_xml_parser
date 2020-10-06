import 'package:runtime/annotations.dart';

@tag('empty')
class EmptyTag {
  EmptyTag();
}

/*
@tag('AltRegistration')
class AltRegistration {
  @from(type: NameTag)
  final String name;
  @from(type: ContactInfo)
  final String email;
  final int age;

  AltRegistration(this.name, this.email, this.age);
}

@tag('attributesTest')
class AttributesTag {
  final String name;
  final int count;
  final double temperature;
  final bool active;

  AttributesTag(this.name, this.temperature, this.active, {this.count = 0});
}

@tag('ContactInfo')
class ContactInfo {
  final String email;
  final String phone;

  ContactInfo(this.email, this.phone);
}

@tag('identification')
class NameTag {
  final String name;

  NameTag(this.name);
}

@tag('registration')
class Registration {
  final NameTag person;
  final ContactInfo contact;
  final int age;

  Registration(this.person, this.contact, this.age);
}
*/
