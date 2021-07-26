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
import 'package:build/build.dart' show AssetId;
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:source_gen/source_gen.dart';

import 'class_info.dart';
import 'method_info.dart';

part 'source_info.g.dart';

final _log = Logger('SourceInfo');

/// Per-file information used by the parser. Serialiazable so that the
/// first-pass builder can output this as JSON then reconstitute
/// in pass two to build the master symbol table as well as drive
/// generation.
abstract class SourceInfo implements Built<SourceInfo, SourceInfoBuilder> {
  static Serializer<SourceInfo> get serializer => _$sourceInfoSerializer;

  factory SourceInfo([void Function(SourceInfoBuilder) updates]) = _$SourceInfo;

  factory SourceInfo.fromLibrary(LibraryReader reader, AssetId asset) {
    final classes = [for (var c in reader.classes) ClassInfo.fromElement(c)];
    _log.finer(
        'SourceInfo(element: ${reader.element}, classes: $classes, uri: ${asset.uri})');
    return SourceInfo((b) {
      b
        ..element = reader.element
        ..classes = classes
        ..uri = asset.uri;
    });
  }

  SourceInfo._();

  Iterable<ClassInfo> get classes;

  LibraryElement get element;

  @memoized
  Iterable<String> get importUris => [
        for (var i in element.imports.where((e) => e.uri != null)) i.uri!
      ]..sort();

  @memoized
  Iterable<MethodInfo> get methods {
    final result = [
      for (var c in classes.where((p) => p.method != null)) c.method!
    ]..sort((a, b) => a.name.compareTo(b.name));
    _log.finer('methods -> $result');
    return result;
  }

  Uri get uri;

  /// Look up the class info object, ignoring the nullability of `t`
  ClassInfo? classForType(DartType t) {
    final t_name = t.getDisplayString(withNullability: false);
    final result = classes.firstWhereOrNull(
        (v) => v.type.getDisplayString(withNullability: false) == t_name);
    _log.finer(() =>
        'classForType(${t.getDisplayString(withNullability: true)}) -> $result');
    return result;
  }

  ClassInfo classNamed(name) => classes.firstWhere((c) => c.typeName == name);

  bool hasClass(name) => classes.any((c) => c.typeName == name);

  Iterable<MethodInfo> methodsReturning(DartType desiredType,
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
      _log.finest('No methods found on $desiredType, looking for subclasses');
      result = [
        for (var c
            in subclassesOf(desiredType).where((sc) => sc.method != null))
          c.method!
      ];
    }
    _log.finer(
        'methodsReturning($desiredType, allowSubtypes: $allowSubtypes) -> $result');
    return result;
  }

  Iterable<ClassInfo> subclassesOf(DartType type) =>
      classes.where((ClassInfo c) => c.type.superclass == type);
}
