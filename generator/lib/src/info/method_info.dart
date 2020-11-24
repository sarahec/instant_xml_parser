/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import 'package:built_value/built_value.dart';
import 'package:generator/src/info/symtable.dart';
import 'package:recase/recase.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import 'class_info.dart';
import 'field_info.dart';

part 'method_info.g.dart';

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

  @memoized
  Iterable<FieldInfo> fields(Symtable symtable) {
    final superclasses = [
      for (var st in classInfo.supertypes) symtable.classForType(st)
    ];
    final _fields = [for (var c in superclasses) c?.element?.fields ?? []]
        .expand((e) => e)
        .toList();
    _fields.addAll(classInfo.element.fields);

    final ctorParams = classInfo.constructor?.parameters ?? [];
    return _fields.where((f) => f.getter.isGetter && !f.isSynthetic).map((f) =>
        FieldInfo.fromElement(
            f,
            ctorParams
                .firstWhere((p) => p.name == f.name, orElse: () => null)
                ?.defaultValueCode)); // should be .first
  }

  String get name => '$prefix$typeName';

  String get prefix;

  @memoized
  String get startVar => '_' + ReCase(typeName).camelCase;

  DartType get type => classInfo.type;

  String get typeName => classInfo.typeName;
}
