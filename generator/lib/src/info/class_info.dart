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
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:ixp_runtime/annotations.dart';

import '../utils/annotation_reader.dart';
import 'constructor_info.dart';
import 'method_info.dart';

part 'class_info.g.dart';

abstract class ClassInfo implements Built<ClassInfo, ClassInfoBuilder> {
  static Serializer<ClassInfo> get serializer => _$classInfoSerializer;

  factory ClassInfo([void Function(ClassInfoBuilder) updates]) = _$ClassInfo;
  factory ClassInfo.fromElement(ClassElement element, [prefix = 'extract']) =>
      ClassInfo((b) => b
        ..element = element
        ..type = element.thisType);
  ClassInfo._();

  ClassElement get element;

  String get constantName => typeName + 'Name';

  @memoized
  MethodInfo get method =>
      needsMethod ? MethodInfo.fromClassInfo(this, element.fields) : null;

  @nullable
  @memoized
  ConstructorInfo get constructor {
    final ctor = element.constructors
        .firstWhere((c) => !c.isFactory && !c.isPrivate, orElse: () => null);
    return (ctor == null) ? null : ConstructorInfo.fromElement(ctor);
  }

  bool get isAbstract => element.isAbstract;

  bool get needsMethod => tagName != null;

  @nullable
  Iterable<DartType> get subclasses;

  Iterable<DartType> get supertypes => element.allSupertypes;

  @memoized
  String get tagName => AnnotationReader.getAnnotation<tag>(element, 'value');

  InterfaceType get type;

  @memoized
  String get typeName => type.getDisplayString(withNullability: false);
}
