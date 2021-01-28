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
import 'package:built_value/built_value.dart';
import 'package:instant_xml_parser/src/info/source_info.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

import 'class_info.dart';
import 'field_info.dart';

part 'method_info.g.dart';

/// Data for a single parser method. Created using `built_value`
abstract class MethodInfo implements Built<MethodInfo, MethodInfoBuilder> {
  factory MethodInfo([void Function(MethodInfoBuilder) updates]) = _$MethodInfo;
  factory MethodInfo.fromClassInfo(
      ClassInfo info, Iterable<FieldElement> fields,
      [prefix = 'extract']) {
    return MethodInfo((b) => b
      ..classInfo = info.toBuilder()
      ..prefix = prefix);
  }

  MethodInfo._();

  ClassInfo get classInfo;

  Iterable<FieldElement> fields(SourceInfo symtable) {
    // Collect all fields
    final superclasses = [
      for (var st in classInfo.supertypes) symtable.classForType(st)
    ];
    return ([for (var c in superclasses) c?.element?.fields ?? []]
            .expand((e) => e)
            .toList()
              ..addAll(classInfo.element.fields))
        .where((f) => f.getter.isGetter && !f.isSynthetic);
  }

  /// Parse all the fields that could be initialized from the constructor
  Iterable<CommonElement> commonElements(SourceInfo symtable) {
    final elements = fields(symtable);
    if (elements.isEmpty) return [];

    final elementNames = Set.of(elements.map((e) => e.name));
    var ctorParams = classInfo.constructor.parameters;
    final common =
        Set.of(ctorParams.map((p) => p.name)).intersection(elementNames);

    // Error checking
    if (!classInfo.hasConstructor) {
      throw InvalidGenerationSourceError(
          'Missing constructor in ${classInfo.typeName}',
          todo:
              'Add a constructor to ${classInfo.typeName} with the fields to be initialized');
    }

    if (common.isEmpty) {
      throw InvalidGenerationSourceError(
          '${classInfo.typeName} has no fields in common with the constructor parameters');
    }

    // Now merge
    final merged = <CommonElement>[];
    for (var name in common) {
      final ctParam = ctorParams.firstWhere((p) => p.name == name);
      final field = FieldInfo.fromElement(
          elements.firstWhere((e) => e.name == name), ctParam.defaultValueCode);
      merged.add(CommonElement(field: field, ctParam: ctParam));
    }
    return merged;
  }

  String get name => '$prefix$typeName';

  /// Parser method names are ${prefix}ClassName. Default prefix is 'extract'
  String get prefix;

  /// The variable name representing this tag
  @memoized
  String get startVar => '_' + ReCase(typeName).camelCase;

  DartType get type => classInfo.type;

  String get typeName => classInfo.typeName;

  @memoized
  Logger get log => Logger('MethodInfo');
}

class CommonElement {
  final FieldInfo field;
  final ParameterElement ctParam;

  CommonElement({@required this.field, @required this.ctParam});
}
