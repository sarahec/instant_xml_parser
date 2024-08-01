/// Utilities for writing an XML parser.
///
/// These add extension methods to XML Events and a StreamQueue of XML Events,
/// enabling code such as:
/// `
/// const NoteName = 'Note';
///
/// Future<Note> extractNote(StreamQueue<XmlEvent> events) async {
///   final _note = await events.find(startTag(named(NoteName))) as XmlStartElementEvent;
///   if (_note == null) return Future.error(MissingStartTag(NoteName));
///   final text = await events.find(textElement(inside(_note))) as XmlTextEvent)?.value;
///   await events.consume(inside(_note)); // move to the end of the tag
///   return Note(text ? '');
/// }
/// `
///
/// ## Preparing the stream:
/// [generateEventsStream] prepares the StreamQueue for use:
///
/// `
/// StreamQueue(source.toXmlEvents().withParentEvents().normalizeEvents().flatten());
/// `
///
/// You will need to call these yourself if your input isn't a
/// `Stream<String>`.
library runtime;

// Copyright 2020, 2024 Google LLC and contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

export 'src/conversion.dart';
export 'src/extensions/consume.dart';
export 'src/extensions/find.dart';
export 'src/extensions/log_unknown.dart';
export 'src/extensions/matcher.dart';
export 'src/extensions/named_attribute.dart';
export 'src/errors.dart';
export 'src/tools.dart';
