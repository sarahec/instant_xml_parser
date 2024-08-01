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
import 'package:analyzer/dart/element/element.dart';
import 'package:logging/logging.dart';
import 'package:source_gen/source_gen.dart';

class AnnotationReader {
  static final _log = Logger('AnnotationReader');

  static dynamic getAnnotation<A>(Element element, String field,
      [Type type = String]) {
    final attributeChecker = TypeChecker.fromRuntime(A);
    final found = attributeChecker.firstAnnotationOfExact(element,
        throwOnUnresolved: false);
    if (found == null) return null;
    dynamic result;
    switch (type) {
      case const (bool):
        result = found.getField(field)?.toIntValue();
        break;
      case const (double):
        result = found.getField(field)?.toDoubleValue();
        break;
      case const (int):
        result = found.getField(field)?.toIntValue();
        break;
      case const (Type):
        result = found.getField(field)?.toTypeValue();
        break;
      default:
        result = found.getField(field)?.toStringValue();
    }
    _log.finer('@$A.$field -> $result');
    return result;
  }

  static dynamic hasAnnotation<A>(Element element) => TypeChecker.fromRuntime(A)
      .hasAnnotationOf(element, throwOnUnresolved: false);
}
