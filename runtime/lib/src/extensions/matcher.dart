import 'package:xml/src/xml_events/utils/named.dart';
import 'package:xml/xml_events.dart';

import 'ancestors.dart';

typedef Matcher = bool Function(XmlEvent event);

Matcher startTag(Matcher match) => (e) => e is XmlStartElementEvent && match(e);

Matcher textElement(Matcher match) => (e) => match(e) && e is XmlTextEvent;

// Matcher endOf(XmlStartElementEvent startTag) => (e) =>
//     (e == startTag && startTag.isSelfClosing) ||
//     (e is XmlEndElementEvent && e.qualifiedName == startTag.qualifiedName) ||
//     !e.descendsFrom(startTag);

Matcher named<T extends XmlNamed>(String qualifiedName) =>
    (e) => e is T && (e as XmlNamed).qualifiedName == qualifiedName;

Matcher inside(XmlStartElementEvent tag) => (e) =>
    (identical(e, tag) && tag.isSelfClosing) ||
    (e is XmlEndElementEvent && identical(e.parentEvent, tag)) ||
    e.descendsFrom(tag);
