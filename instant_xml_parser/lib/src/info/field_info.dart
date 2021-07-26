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
import 'package:instant_xml_parser/src/utils/annotation_reader.dart';
import 'package:ixp_runtime/annotations.dart';

part 'field_info.g.dart';

/// A single field, parsed. Created using ```built_value```
abstract class FieldInfo implements Built<FieldInfo, FieldInfoBuilder> {
  factory FieldInfo([void Function(FieldInfoBuilder) updates]) = _$FieldInfo;
  factory FieldInfo.fromElement(
          FieldElement element, String? defaultValueCode) =>
      FieldInfo((b) => b
        ..element = element
        ..defaultValueCode = defaultValueCode);

  FieldInfo._();

  FieldElement get element;

  /// If this has a default value, contains its source code, else null
  String? get defaultValueCode;

  /// Either the name specified in @alias, or the element's name
  @memoized
  String get attributeName =>
      AnnotationReader.getAnnotation<alias>(element, 'name') ?? element.name;

  /// Contents of the @convert tag, if present, else null
  @memoized
  String get conversion =>
      AnnotationReader.getAnnotation<convert>(element, 'source');

  /// Contents of the @convert tag, if present, else null
  @memoized
  String get customTemplate =>
      AnnotationReader.getAnnotation<custom>(element, 'template');

  /// True if annotated with @convert
  @memoized
  bool get hasConversion => AnnotationReader.hasAnnotation<convert>(element);

  /// Attribute heuristic: primitive type or annotated w/ @convert, not xml text.
  bool get isAttributeField =>
      (hasConversion || isPrimitive || isUri) && !isXmlTextField;

  /// Is this a child tag?
  bool get isChildField => !isAttributeField && !isXmlTextField;

  /// Has this been annotated with ```@custom```
  @memoized
  bool get isCustom => AnnotationReader.hasAnnotation<custom>(element);

  /// True for custom fields, as they need to be assigned just before the constructor
  bool get isDeferred => isCustom && isAttributeField;

  /// True if this field contains a list
  bool get isList => element.type.isDartCoreList;

  /// True if this field is ```bool```, ```double```, ```int```, or ```String```
  bool get isPrimitive => (type.isDartCoreBool ||
      type.isDartCoreDouble ||
      type.isDartCoreInt ||
      type.isDartCoreString);

  /// True if this field is a ```Uri``` (used to convert via ```Uri.parse```)
  @memoized
  bool get isUri =>
      element.type.getDisplayString(withNullability: false) == 'Uri';

  /// True if this field should come from ```XmlTextEvent```
  @memoized
  bool get isXmlTextField =>
      AnnotationReader.hasAnnotation<TextElement>(element);

  /// Field name
  @memoized
  String get name => element.name;

  /// Contents of @trueIfEquals annotation, if present
  String? get trueIfEquals =>
      AnnotationReader.getAnnotation<ifEquals>(element, 'value');

  /// Contents of @trueIfMatches annotation, if present
  String? get trueIfMatches =>
      AnnotationReader.getAnnotation<ifMatches>(element, 'regex');

  /// Field type
  @memoized
  DartType get type => element.type.isDartCoreList
      ? (element.type as ParameterizedType).typeArguments.first
      : element.type;

  /// Field type as String
  @memoized
  String get typeName => type.getDisplayString(withNullability: false);
}
