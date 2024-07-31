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
import 'package:instant_xml_parser/ixp_core.dart';
import 'package:ixp_runtime/annotations.dart';
import 'package:source_gen/source_gen.dart';

/// Represents one class in the source file
extension ClassInfo on ClassElement {
  /// Stored class type
  InterfaceType get type => thisType;

  /// Constant name to use for this tag
  String get constantName => '${typeName}Name';

  /// Constructor using this class' fields
  ConstructorElement get constructor =>
      constructors.singleWhereOrNull(
          (c) => AnnotationReader.hasAnnotation<Constructor>(c)) ??
      constructors.singleWhere((c) => !c.isFactory && !c.isPrivate,
          orElse: () => throw InvalidGenerationSourceError(
              'No constructor found in $typeName',
              todo:
                  'Annotate desired constructor in $typeName w/ @constructor'));

  /// True if there's a suitable constuctor on this call
  bool get hasConstructor =>
      constructors.any((c) => !c.isFactory && !c.isPrivate);

  /// Has this class been annotated with @tag?
  bool get needsMethod => tagName != null;

  /// What are this class' superclasses?
  Iterable<DartType> get supertypes => allSupertypes;

  /// What's the XML tag?
  String? get tagName => AnnotationReader.getAnnotation<tag>(this, 'value');

  /// String name of this class
  String get typeName => type.element.name;
}
