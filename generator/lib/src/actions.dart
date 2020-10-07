library parse_generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:runtime/annotations.dart';

import 'annotation_reader.dart';

abstract class ActionGenerator with AnnotationReader {
  factory ActionGenerator.fromElement(FieldElement element) =>
      _isPrimitive(element.type)
          ? AttributeActionGenerator.fromElement(element)
          : MethodActionGenerator.fromElement(element);
  String get entryType;

  String get fieldName;

  Code get toAction;

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
  final String tag;
  final String trueIfEquals;
  final RegExp trueIfMatches;

  // final String defaultValue; // will come from constructor

  AttributeActionGenerator.fromElement(FieldElement element)
      : fieldName = element.name,
        type = element.type,
        attribute = AnnotationReader.getAnnotation<attr>(element, 'name') ??
            element.name,
        tag = AnnotationReader.getAnnotation<from>(element, 'tag'),
        trueIfEquals =
            AnnotationReader.getAnnotation<ifEquals>(element, 'value'),
        trueIfMatches =
            AnnotationReader.getAnnotation<ifMatches>(element, 'regex');

  @override
  String get entryType => type.getDisplayString(withNullability: false);

  @override
  Code get toAction {
    assert(type != null);
    var conversion = '';
    if (type.isDartCoreBool && trueIfEquals != null) {
      conversion = ", convert: Convert.ifEquals('$trueIfEquals'}";
    } else if (type.isDartCoreBool && trueIfMatches != null) {
      conversion = ', convert: Convert.ifMatches($trueIfMatches}';
    }
    return Code(
        "GetAttr<$entryType>('$attribute', key: '$fieldName' $conversion)");
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
  String get entryType => type.getDisplayString(withNullability: false);

  String get methodName => 'extract$entryType';

  @override
  Code get toAction => Code(
      "GetTag<$entryType>(${entryType}Name, $methodName, key: '$fieldName')");
}
