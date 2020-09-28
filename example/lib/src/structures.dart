import 'package:runtime/annotations.dart';

@Tag('empty', useStrict: true)
class EmptyTag {
  EmptyTag();
}

@Tag('identification')
class NameTag {
  final String name;

  NameTag(this.name);
}

@Tag('attributesTest')
class AttributesTag {
  @Attribute(isRequired: true)
  final String name;
  @Attribute(defaultValue: 0)
  final int count;
  final double temperature;
  final bool active;

  AttributesTag(this.name, this.count, this.temperature, this.active);
}

@Tag('registration')
class Registration {
  final NameTag person;
  final ContactInfo contact;
  final int age;

  Registration(this.person, this.contact, this.age);
}

@Tag('ContactInfo')
class ContactInfo {
  final String email;
  final String phone;

  ContactInfo(this.email, this.phone);
}
