library parse_generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:runtime/annotations.dart';

import 'annotation_reader.dart';

abstract class ActionGenerator with AnnotationReader {
  factory ActionGenerator.fromElement(FieldElement element) {
    final isList = element.type.isDartCoreList;
    final valueType = isList
        ? (element.type as ParameterizedType).typeArguments.first
        : element.type;
    return (!isList && _isPrimitive(valueType))
        ? AttributeActionGenerator.fromElement(element, valueType)
        // TODO Add text field type (aka inline tag)
        : MethodActionGenerator.fromElement(element, valueType, isList);
  }
  String get typeName;

  String get fieldName;

  DartType get type;

  static bool _isPrimitive(DartType type) => (type.isDartCoreBool ||
      type.isDartCoreDouble ||
      type.isDartCoreInt ||
      type.isDartCoreString);
}

class AttributeActionGenerator implements ActionGenerator {
  @override
  final String fieldName;
  @override
  final DartType type;
  final String attribute;
  final String trueIfEquals;
  final RegExp trueIfMatches;

  // final String defaultValue; // will come from constructor

  AttributeActionGenerator.fromElement(FieldElement element, this.type)
      : fieldName = element.name,
        attribute = AnnotationReader.getAnnotation<alias>(element, 'name') ??
            element.name,
        trueIfEquals =
            AnnotationReader.getAnnotation<ifEquals>(element, 'value'),
        trueIfMatches =
            AnnotationReader.getAnnotation<ifMatches>(element, 'regex');

  @override
  String get typeName => type.getDisplayString(withNullability: false);

  Code toAction(String sourceVar) {
    assert(type != null);
    var conversion = '';
    if (type.isDartCoreBool) {
      if (trueIfEquals != null) {
        conversion = ", convert: Convert.ifEquals('$trueIfEquals'}";
      } else if (trueIfMatches != null) {
        conversion = ', convert: Convert.ifMatches($trueIfMatches}';
      }
    }
    // BUGBUG Need to get the correct name for the source tag
    return Code(
        "final $fieldName = await _pr.namedAttribute<$typeName>($sourceVar, '$fieldName' $conversion);");
  }
}

class MethodActionGenerator implements ActionGenerator {
  @override
  final String fieldName;
  @override
  final DartType type;
  final bool isList;

  MethodActionGenerator.fromElement(
      FieldElement element, this.type, this.isList)
      : fieldName = element.name;

  @override
  String get typeName => type.getDisplayString(withNullability: false);

  String get constantName => typeName + 'Name';

  String get methodName => 'extract$typeName';

  String get vardecl => "var $fieldName ${isList ? '= [];' : ';'}";

  String get methodCall => 'await $methodName(events)';

  Code toAction() => Code('''
    case $constantName:
      $fieldName${isList ? '.add($methodCall)' : '= $methodCall'};
    break;''');
}
