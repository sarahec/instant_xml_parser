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
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:source_gen/source_gen.dart';

import 'package:instant_xml_parser/ixp_core.dart';

final _log = Logger('SourceInfo');

/// Per-file information used by the parser.
extension SourceInfo on LibraryReader {
  Iterable<String> get importUris => [
        for (var i in element.imports.where((e) => e.uri != null)) i.uri!
      ]..sort();

  Iterable<ClassElement> get methods {
    final result = [for (var c in classes.where((p) => p.needsMethod)) c]
      ..sort((a, b) => a.name.compareTo(b.name));
    _log.finer('methods -> $result');
    return result;
  }

  /// Look up the class info object, ignoring the nullability of `t`
  ClassElement? classForType(DartType t) {
    final t_name = t.getDisplayString(withNullability: false);
    final result = classes.firstWhereOrNull(
        (v) => v.type.getDisplayString(withNullability: false) == t_name);
    _log.finer(() =>
        'classForType(${t.getDisplayString(withNullability: true)}) -> $result');
    return result;
  }

  Iterable<ClassElement> methodsReturning(DartType desiredType,
      [allowSubtypes = true]) {
    // We have a problem: returned types are non-nullable, but a field's type
    // may be. So, convert both to type names without nullability and match.
    // (It may be hacky, but requires the least implementation knowledge of
    // the type system, and is therefore safest.)
    final desiredTypeName =
        desiredType.getDisplayString(withNullability: false);
    var result = methods.where((m) =>
        m.type.getDisplayString(withNullability: false) == desiredTypeName);
    if (result.isEmpty && allowSubtypes) {
      _log.finest('No methods return $desiredType, looking for subclasses');
      result = subclassesOf(desiredType).where((sc) => sc.needsMethod);
    }
    _log.finer(
        'methodsReturning($desiredType, allowSubtypes: $allowSubtypes) -> $result');
    return result;
  }

  Iterable<ClassElement> subclassesOf(DartType type) {
    final t_name = type.getDisplayString(withNullability: false);
    return classes.where((v) =>
        v.type.superclass?.getDisplayString(withNullability: false) == t_name);
  }
}
