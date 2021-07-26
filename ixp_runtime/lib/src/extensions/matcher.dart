/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/// Matchers for the [find] operation.
///
/// These support expressions such as `find(startTag(named('Foo')))` and
/// `textElement(inside(tag))`.
import 'package:xml/src/xml_events/utils/named.dart';
import 'package:xml/xml_events.dart';

import 'ancestors.dart';

/// True if the current event is the between the specified start tag and its
/// end tag, inclusive.
///
/// [tag] The start of the parent tag.
Matcher inside(XmlStartElementEvent tag) => ((e) => (identical(e, tag) ||
    (e is XmlEndElementEvent && identical(tag, e.parentEvent)) ||
    e.descendsFrom(tag)));

/// Matches tags with the provided qualified name.
///
/// [desiredName] the fully qualified name, including namespace prefix if
/// needed (e.g. `foo:bar`)
Matcher named(String desiredName) =>
    ((e) => e is XmlNamed && (e as XmlNamed).qualifiedName == desiredName);

Matcher not(Matcher match) => ((e) => !match(e));

/// Wraps another matcher so it only sees `XmlStartElementEvent`.
///
/// [match] the matcher to wrap, such as [named]
Matcher<XmlStartElementEvent> startTag([Matcher<XmlEvent>? match]) =>
    ((e) => e is XmlStartElementEvent && (match == null || match(e)));

/// Wraps another matcher so it only sees `XmlTextEvent`.
///
/// [match] the matcher to wrap, such as [inside]
Matcher<XmlTextEvent> textElement([Matcher? match]) =>
    ((e) => e is XmlTextEvent && (match == null || match(e)));

typedef Matcher<T extends XmlEvent> = bool Function(XmlEvent event);
