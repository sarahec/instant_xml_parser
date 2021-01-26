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
import 'package:source_gen/source_gen.dart';

import 'class_info.dart';
import 'method_info.dart';

part 'source_info.g.dart';

/// Per-file information used by the parser. Serialiazable so that the
/// first-pass builder can output this as JSON then reconstitute
/// in pass two to build the master symbol table as well as drive
/// generation.
abstract class SourceInfo implements Built<SourceInfo, SourceInfoBuilder> {
  static Serializer<SourceInfo> get serializer => _$sourceInfoSerializer;

  factory SourceInfo([void Function(SourceInfoBuilder) updates]) = _$SourceInfo;

  factory SourceInfo.fromLibrary(LibraryReader reader, AssetId asset) {
    return SourceInfo((b) => b
      ..element = reader.element
      ..classes = [for (var c in reader.classes) ClassInfo.fromElement(c)]
      ..uri = asset.uri);
  }

  SourceInfo._();

  Iterable<ClassInfo> get classes;

  LibraryElement get element;

  @memoized
  Iterable<String> get importUris => element.imports.map((i) => i.uri);

  @memoized
  Iterable<MethodInfo> get methods => classes
      .map((c) => c.method)
      .where((c) => c != null)
      .toList(growable: false)
        ..sort((a, b) => a.name.compareTo(b.name));

  Uri get uri;

  ClassInfo classForType(DartType t) =>
      classes.firstWhere((v) => v.type == t, orElse: () => null);

  ClassInfo classNamed(name) => classes.firstWhere((c) => c.typeName == name);

  bool hasClass(name) => classes.any((c) => c.typeName == name);

  Iterable<MethodInfo> methodsReturning(DartType desiredType,
      [allowSubtypes = true]) {
    var result = methods.where((m) => m.type == desiredType);
    if (result.isEmpty && allowSubtypes) {
      result = subclassesOf(desiredType)?.map((c) => c.method);
    }
    return (result == null || result.isEmpty) ? null : result;
  }

  Iterable<ClassInfo> subclassesOf(DartType type) =>
      classes.where((ClassInfo c) => c.type.superclass == type).toList();
}
