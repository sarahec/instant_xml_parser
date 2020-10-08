library parse_generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:recase/recase.dart';
import 'package:runtime/annotations.dart';

import 'annotation_reader.dart';

abstract class ActionGenerator with AnnotationReader {
  factory ActionGenerator.fromElement(FieldElement element) =>
      _isPrimitive(element.type)
          ? AttributeActionGenerator.fromElement(element)
          : MethodActionGenerator.fromElement(element);
  String get typeName;

  String get fieldName;

  DartType get type;

  // TODO Also handle lists/iterables of primitives
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
  final String sourceTag;
  final String trueIfEquals;
  final RegExp trueIfMatches;

  // final String defaultValue; // will come from constructor

  AttributeActionGenerator.fromElement(FieldElement element)
      : fieldName = element.name,
        type = element.type,
        attribute =
            AnnotationReader.getAnnotation<from>(element, 'attribute') ??
                element.name,
        sourceTag = AnnotationReader.getAnnotation<from>(element, 'tag'),
        trueIfEquals =
            AnnotationReader.getAnnotation<ifEquals>(element, 'value'),
        trueIfMatches =
            AnnotationReader.getAnnotation<ifMatches>(element, 'regex');

  @override
  String get typeName => type.getDisplayString(withNullability: false);

  Code toAction(String sourceVar) {
    assert(type != null);
    assert(sourceTag == null, '@from(attr, tag) not implemented yet');
    var conversion = '';
    if (type.isDartCoreBool && trueIfEquals != null) {
      conversion = ", convert: Convert.ifEquals('$trueIfEquals'}";
    } else if (type.isDartCoreBool && trueIfMatches != null) {
      conversion = ', convert: Convert.ifMatches($trueIfMatches}';
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

  MethodActionGenerator.fromElement(FieldElement element)
      : fieldName = element.name,
        type = element.type;

  @override
  String get typeName => type.getDisplayString(withNullability: false);

  String get constantName => typeName + 'Name';

  String get methodName => 'extract$typeName';

  String get varName => ReCase(typeName).camelCase;

  Code toAction() => Code('''
    case $constantName:
      $varName = await $methodName(events);
    break;''');
}
