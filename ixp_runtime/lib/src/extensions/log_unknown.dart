// Copyright 2020 Google LLC
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
import 'package:logging/logging.dart';
import 'package:xml/xml_events.dart';

extension Logging on XmlStartElementEvent {
  static final _log = Logger('logUnknown:');

  /// Utility to log an "unknown tag" message. Logs at the `warning` level.
  ///
  /// [expected] the expected tag's name or a list of names
  void logUnknown({dynamic expected = '(any)'}) => _log.warning(
      "skipping '$qualifiedName'${parentEvent != null ? ' in $parentEvent' : ''}, expected '$qualifiedName'");
}
