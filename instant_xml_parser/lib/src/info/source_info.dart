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
        for (var i in element.libraryImports)
          i.importedLibrary?.librarySource.uri.toString() ?? i.uri.toString()
      ]..sort();

  Iterable<ClassElement> get classesForParser => [
        for (var c in classes.where((p) => p.needsMethod)) c
      ]..sort((a, b) => a.name.compareTo(b.name));

  /// Look up the class info object, ignoring the nullability of `t`
  ClassElement? classForType(DartType t) {
    final baseType = element.typeSystem.promoteToNonNull(t);
    return classes.firstWhereOrNull((v) => v.thisType == baseType);
  }

  Iterable<ClassElement> allClassesForType(DartType desiredType,
      [allowSubtypes = true]) {
    final baseType = element.typeSystem.promoteToNonNull(desiredType);
    var result = classesForParser.where((c) => c.thisType == baseType);
    if (result.isEmpty && allowSubtypes) {
      result = subclassesOf(desiredType).where((sc) => sc.needsMethod);
    }
    return result;
  }

  Iterable<ClassElement> subclassesOf(DartType supertype) {
    final baseType = element.typeSystem.promoteToNonNull(supertype);
    return classes.where((c) => c.allSupertypes.contains(baseType));
  }
}
