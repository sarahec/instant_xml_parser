import 'package:xml/xml_events.dart';

typedef Convert = dynamic Function(String s);

dynamic namedAttribute(XmlStartElementEvent element, String name,
    [Convert converter]) {
  final attribute =
      element.attributes.firstWhere((a) => a.name == name, orElse: () => null);
  final value = attribute?.value;

  return value == null ? null : (converter == null ? value : converter(value));
}
