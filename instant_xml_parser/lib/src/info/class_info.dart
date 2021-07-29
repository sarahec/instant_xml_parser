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
import 'package:ixp_runtime/annotations.dart';

import '../utils/annotation_reader.dart';
import 'method_info.dart';

/// Represents one class in the source file
class ClassInfo {
  final String prefix;

  /// Parsed class
  final ClassElement element;

  /// Stored class type
  final InterfaceType type;

  ClassInfo.fromElement(this.element, [this.prefix = 'extract'])
      : type = element.thisType;

  /// Constant name to use for this tag
  String get constantName => typeName + 'Name';

  /// Constructor using this class' fields
  ConstructorElement get constructor =>
      element.constructors.firstWhere((c) => !c.isFactory && !c.isPrivate);

  /// True if there's a suitable constuctor on this call
  bool get hasConstructor =>
      element.constructors.any((c) => !c.isFactory && !c.isPrivate);

  /// Is this an abstract class?
  ///
  /// No parser method if so; will be implemented as a method for each concrete
  /// subclass.
  bool get isAbstract => element.isAbstract;

  /// The method code for this class or null (if not marked with @tag)
  MethodInfo? get method => needsMethod ? MethodInfo.fromClassInfo(this) : null;

  /// Has this class been annotated with @tag?
  bool get needsMethod => tagName != null;

  /// What are this class' superclasses?
  Iterable<DartType> get supertypes => element.allSupertypes;

  /// What's the XML tag?
  String? get tagName => AnnotationReader.getAnnotation<tag>(element, 'value');

  /// String name of this class
  String get typeName => type.getDisplayString(withNullability: false);
}
