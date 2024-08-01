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
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:logging/logging.dart';
import 'package:recase/recase.dart';
import 'package:source_gen/source_gen.dart';

import 'package:instant_xml_parser/ixp_core.dart';

class CommonElement {
  final FieldInfo field;
  final ParameterElement ctParam;

  CommonElement({required this.field, required this.ctParam});
  String? get defaultValue => field.defaultValueCode;
  bool get hasDefaultValue => field.defaultValueCode != null;

  bool get isNullable =>
      field.type.nullabilitySuffix == NullabilitySuffix.question;
}

/// Data for a single parser method. Created using `built_value`
extension MethodInfo on ClassElement {
  /// Parser method names are ${prefix}ClassName. Default prefix is 'extract'
  static final prefix = 'extract';

  Logger get log => Logger('MethodInfo');

  String get methodName => '$prefix$typeName';

  /// The variable name representing this tag
  String get startVar => '_' + ReCase(typeName).camelCase;

  /// Parse all the fields that could be initialized from the constructor
  Iterable<CommonElement> get commonElements {
    final elements = fieldsForMethod;
    if (elements.isEmpty) return [];

    final elementNames = Set.of(elements.map((e) => e.name));
    var ctorParams = constructor.parameters;
    final common =
        Set.of(ctorParams.map((p) => p.name)).intersection(elementNames);

    // Error checking
    if (!hasConstructor) {
      throw InvalidGenerationSourceError('Missing constructor in $typeName',
          todo:
              'Add a constructor to $typeName with the fields to be initialized');
    }

    if (common.isEmpty) {
      log.fine(
          '$typeName has no fields in common with the constructor parameters, calling empty constructor.');
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

  Iterable<FieldElement> get fieldsForMethod {
    final result = <FieldElement>[];

    // Collect all fields
    for (var c in allSupertypes) {
      result.addAll(c.element.fields);
    }
    result.addAll(fields);
    return result.where((f) => f.getter!.isGetter && !f.isSynthetic);
  }
}
