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
import 'package:xml/xml_events.dart';
import 'package:xml/src/xml_events/utils/parented.dart';

extension Ancestors on XmlParented {
  bool descendsFrom(ancestor) =>
      // can't use '.contains' since it depends on equality, so will return false
      // positives for two events of the same type without any attributes
      ancestor == null ? false : ancestors.any((e) => identical(e, ancestor));

  Iterable<XmlEvent> get ancestors sync* {
    var probe = parentEvent;
    while (probe != null) {
      yield probe;
      probe = probe?.parentEvent;
    }
  }
}
