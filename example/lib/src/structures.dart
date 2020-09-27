import 'package:runtime/annotations.dart';

@Tag('empty', useStrict: true)
class EmptyTag {
  EmptyTag();
}

@Tag('named')
class NamedTag {
  final String name;

  NamedTag(this.name);
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
  final NamedTag person;
  final int age;

  Registration(this.person, this.age);
}
