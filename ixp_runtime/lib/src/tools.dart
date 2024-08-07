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
library runtime;

import 'package:async/async.dart';
import 'package:xml/xml_events.dart';

/// Converts a stream of Strings, such as from a file, to to a StreamQueue of
/// XML Events ready for parsing.
///
/// The converted stream has three important features: every event contains a
/// reference to its "parent" (enclosing) event, comments have been stripped,
/// and runs of XML Text events have been coalesced together. The parser
/// utilities need these three things to be true.
StreamQueue<XmlEvent> generateEventStream(Stream<String> source) => StreamQueue(
    source.toXmlEvents().withParentEvents().normalizeEvents().flatten());
