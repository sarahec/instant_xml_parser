import 'package:xml/xml_events.dart';

import 'converters.dart';

dynamic namedAttribute(XmlStartElementEvent element, String name,
    [Convert converter]) {
  final attribute =
      element.attributes.firstWhere((a) => a.name == name, orElse: () => null);
  final value = attribute?.value;

  return value == null ? null : (converter == null ? value : converter(value));
}
