import 'package:runtime/annotations.dart';

@Tag('empty')
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
  final String name;
  final int count;
  final double temperature;
  final bool active;

  AttributesTag(this.name, this.count, this.temperature, this.active);
}
