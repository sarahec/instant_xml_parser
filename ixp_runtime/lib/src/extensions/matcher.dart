/// Matchers for the [find] operation.
///
/// These support expressions such as ```find(startTag(named('Foo')))``` and
/// ```textElement(inside(tag))```.
import 'package:xml/src/xml_events/utils/named.dart';
import 'package:xml/xml_events.dart';

import 'ancestors.dart';

/// Matches the contents of the specified tag.
///
/// [tag] The start of the parent tag.
Matcher inside(XmlEvent? tag) => ((e) =>
    tag is XmlStartElementEvent &&
    ((identical(e, tag) && tag.isSelfClosing) ||
        (e is XmlEndElementEvent && identical(tag, e.parentEvent)) ||
        e.descendsFrom(tag)));

/// Matches tags with the provided qualified name.
///
/// [qualifiedName] the fully qualified name, including namespace prefix if
/// needed (e.g. ```foo:bar```)
Matcher named(String qualifiedName) =>
    ((e) => e is XmlNamed && (e as XmlNamed).qualifiedName == qualifiedName);

Matcher not(Matcher match) => ((e) => !match(e));

/// Wraps another matcher so it only sees ```XmlStartElementEvent```.
///
/// [match] the matcher to wrap, such as [named]
Matcher<XmlStartElementEvent> startTag([Matcher<XmlEvent>? match]) =>
    ((e) => e is XmlStartElementEvent && (match == null || match(e)));

/// Wraps another matcher so it only sees ```XmlTextEvent```.
///
/// [match] the matcher to wrap, such as [inside]
Matcher<XmlTextEvent> textElement([Matcher? match]) =>
    ((e) => e is XmlTextEvent && (match == null || match(e)));

typedef Matcher<T extends XmlEvent> = bool Function(XmlEvent event);
