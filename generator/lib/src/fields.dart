library parse_generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:runtime/annotations.dart';

import 'annotation_reader.dart';
import 'method_info.dart';

enum Section { attributesSection, textSection, childSection }

abstract class FieldGenerator {
  final MethodInfo context;
  final String fieldName;
  final bool isList;
  final DartType type;

  FieldGenerator(this.fieldName, this.type, this.context,
      [this.isList = false]);

  factory FieldGenerator.fromElement(FieldElement element, MethodInfo context) {
    final isList = element.type.isDartCoreList;
    final fieldType = isList
        ? (element.type as ParameterizedType).typeArguments.first
        : element.type;
    if (AnnotationReader.hasAnnotation<text>(element)) {
      return TextFieldGenerator(element.name, fieldType, context, isList);
    }
    return (!isList && _isPrimitive(fieldType))
        ? AttributeFieldGenerator(element, fieldType, context)
        : TagFieldGenerator(element.name, fieldType, context, isList);
  }

  Section get section;
  String get toAction;
  String get typeName => type.getDisplayString(withNullability: false);

  static bool _isPrimitive(DartType type) => (type.isDartCoreBool ||
      type.isDartCoreDouble ||
      type.isDartCoreInt ||
      type.isDartCoreString);
}

class AttributeFieldGenerator extends FieldGenerator {
  final String attribute;
  final String trueIfEquals;
  final RegExp trueIfMatches;
  @override
  final section = Section.attributesSection;

  // final String defaultValue; // will come from constructor

  AttributeFieldGenerator(
      FieldElement element, DartType type, MethodInfo context)
      : attribute = AnnotationReader.getAnnotation<alias>(element, 'name') ??
            element.name,
        trueIfEquals =
            AnnotationReader.getAnnotation<ifEquals>(element, 'value'),
        trueIfMatches =
            AnnotationReader.getAnnotation<ifMatches>(element, 'regex'),
        super(element.name, type, context);

  @override
  String get toAction {
    assert(type != null);
    var conversion = '';
    if (type.isDartCoreBool) {
      if (trueIfEquals != null) {
        conversion = ", convert: Convert.ifEquals('$trueIfEquals'}";
      } else if (trueIfMatches != null) {
        conversion = ', convert: Convert.ifMatches($trueIfMatches}';
      }
    }
    return "final $fieldName = await _pr.namedAttribute<$typeName>(${context.startVar}, '$fieldName' $conversion);";
  }
}

class TextFieldGenerator extends FieldGenerator {
  @override
  final section = Section.textSection;

  TextFieldGenerator(fieldName, type, context, isList)
      : super(fieldName, type, context, isList);

  @override
  String get toAction =>
      'final $fieldName = await _pr.textOf(events, ${context.startVar});';
}

mixin ChildGenerator on FieldGenerator {
  String get action;

  String get requiredTag;

  String get vardecl => "var $fieldName ${isList ? '= [];' : ';'}";

  @override
  String get toAction => '''
    case $requiredTag:
      $fieldName${isList ? '.add($action)' : '= $action'};
    break;''';
}

class TagFieldGenerator extends FieldGenerator with ChildGenerator {
  @override
  final section = Section.childSection;

  TagFieldGenerator(fieldName, type, context, isList)
      : super(fieldName, type, context, isList);

  @override
  String get action => 'await $methodName(events)';

  String get methodName => 'extract$typeName';

  @override
  String get requiredTag => typeName + 'Name';
}
