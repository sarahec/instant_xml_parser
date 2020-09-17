import 'dart:async';
import 'package:async/async.dart';
import 'package:runtime/annotations.dart';
import 'package:runtime/parse_tools.dart';
import 'package:xml/xml_events.dart';

part 'example.g.dart';

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

// @FromXML('wrapper')
class NamedChildWrapper {
  final NamedTag child;

  NamedChildWrapper(this.child);
}
