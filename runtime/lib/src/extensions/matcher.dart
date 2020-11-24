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
