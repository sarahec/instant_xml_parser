import 'package:xml/xml_events.dart';

String getID(XmlStartElementEvent element) => element.attributes
    .firstWhere((a) => a.qualifiedName == 'id', orElse: () => null)
    ?.value;
