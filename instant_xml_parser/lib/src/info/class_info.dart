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
import 'method_info.dart';

part 'class_info.g.dart';

/// Represents one class in the source file
abstract class ClassInfo implements Built<ClassInfo, ClassInfoBuilder> {
  static Serializer<ClassInfo> get serializer => _$classInfoSerializer;

  factory ClassInfo([void Function(ClassInfoBuilder) updates]) = _$ClassInfo;
  factory ClassInfo.fromElement(ClassElement element, [prefix = 'extract']) =>
      ClassInfo((b) => b
        ..element = element
        ..type = element.thisType);
  ClassInfo._();

  /// Constant name to use for this tag
  String get constantName => typeName + 'Name';

  /// Constructor using this class' fields
  @memoized
  ConstructorElement get constructor =>
      element.constructors.firstWhere((c) => !c.isFactory && !c.isPrivate);

  /// Parsed class
  ClassElement get element;

  /// True if there's a suitable constuctor on this call
  bool get hasConstructor =>
      element.constructors.any((c) => !c.isFactory && !c.isPrivate);

  /// Is this an abstract class?
  ///
  /// No parser method if so; will be implemented as a method for each concrete
  /// subclass.
  bool get isAbstract => element.isAbstract;

  /// The method code for this class or null (if not marked with @tag)
  @memoized
  MethodInfo get method =>
      needsMethod ? MethodInfo.fromClassInfo(this, element.fields) : null;

  /// Has this class been annotated with @tag?
  bool get needsMethod => tagName != null;

  /// All of the immediate sublclasses of this class (in this source file only)
  @nullable
  Iterable<DartType> get subclasses;

  /// What are this class' superclasses?
  Iterable<DartType> get supertypes => element.allSupertypes;

  /// What's the XML tag?
  @memoized
  String get tagName => AnnotationReader.getAnnotation<tag>(element, 'value');

  /// Stored class type
  InterfaceType get type;

  /// String name of this class (generated only once, then memoized)
  @memoized
  String get typeName => type.getDisplayString(withNullability: false);
}
