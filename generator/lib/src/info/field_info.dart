import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:built_value/built_value.dart';
import 'package:generator/src/utils/annotation_reader.dart';
import 'package:runtime/annotations.dart';

part 'field_info.g.dart';

abstract class FieldInfo implements Built<FieldInfo, FieldInfoBuilder> {
  factory FieldInfo([void Function(FieldInfoBuilder) updates]) = _$FieldInfo;
  factory FieldInfo.fromElement(
          FieldElement element, String defaultValueCode) =>
      FieldInfo((b) => b
        ..element = element
        ..defaultValueCode = defaultValueCode);

  FieldInfo._();

  FieldElement get element;

  /// If this has a default value, contains its source code, else null
  @nullable
  String get defaultValueCode;

  @memoized
  String get attributeName =>
      AnnotationReader.getAnnotation<alias>(element, 'name') ?? element.name;

  bool get isAttributeField => isPrimitive && !isXmlTextField;

  bool get isChildField => !isPrimitive && !isXmlTextField;

  bool get isList => element.type.isDartCoreList;

  bool get isPrimitive => (type.isDartCoreBool ||
      type.isDartCoreDouble ||
      type.isDartCoreInt ||
      type.isDartCoreString);

  @memoized
  bool get isXmlTextField => AnnotationReader.hasAnnotation<text>(element);

  @memoized
  String get name => element.name;

  String get trueIfEquals =>
      AnnotationReader.getAnnotation<ifEquals>(element, 'value');

  String get trueIfMatches =>
      AnnotationReader.getAnnotation<ifMatches>(element, 'regex');

  @memoized
  DartType get type => element.type.isDartCoreList
      ? (element.type as ParameterizedType).typeArguments.first
      : element.type;

  @memoized
  String get typeName => type.getDisplayString(withNullability: false);
}
