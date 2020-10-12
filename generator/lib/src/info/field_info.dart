import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:built_value/built_value.dart';
import 'package:generator/src/utils/annotation_reader.dart';
import 'package:runtime/annotations.dart';

part 'field_info.g.dart';

abstract class FieldInfo implements Built<FieldInfo, FieldInfoBuilder> {
  factory FieldInfo([void Function(FieldInfoBuilder) updates]) = _$FieldInfo;
  factory FieldInfo.fromElement(FieldElement element) => FieldInfo((b) => b
    ..name = element.getDisplayString(withNullability: false)
    ..type = element.type.isDartCoreList
        ? (element.type as ParameterizedType).typeArguments.first
        : element.type
    ..isList = element.type.isDartCoreList
    ..isText = AnnotationReader.hasAnnotation<text>(element)
    ..attribute =
        AnnotationReader.getAnnotation<alias>(element, 'name') ?? element.name
    ..trueIfEquals = AnnotationReader.getAnnotation<ifEquals>(element, 'value')
    ..trueIfMatches =
        AnnotationReader.getAnnotation<ifMatches>(element, 'regex'));

  FieldInfo._();

  @nullable
  String get attribute;

  bool get isList;

  bool get isPrimitive => (type.isDartCoreBool ||
      type.isDartCoreDouble ||
      type.isDartCoreInt ||
      type.isDartCoreString);

  bool get isText;

  String get name;

  @nullable
  String get trueIfEquals;

  @nullable
  String get trueIfMatches;

  DartType get type;

  @memoized
  String get typeName => type.getDisplayString(withNullability: false);
}
