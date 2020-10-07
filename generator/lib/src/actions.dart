library parse_generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';
import 'package:runtime/annotations.dart';
import 'package:source_gen/source_gen.dart';

import 'annotation_reader.dart';

abstract class ActionGenerator with AnnotationReader {
  factory ActionGenerator.fromElement(FieldElement element) =>
      _isPrimitive(element.type)
          ? AttributeActionGenerator.fromElement(element)
          : MethodActionGenerator.fromElement(element);
  String get entryType;

  String get name;

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
  final String name;
  @override
  final DartType type;
  final String attribute;
  final String tag;
  final String trueIfEquals;
  final RegExp trueIfMatches;

  // final String defaultValue; // will come from constructor

  AttributeActionGenerator.fromElement(FieldElement element)
      : name = element.name,
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
    return Code("GetAttr<$entryType>('$attribute' $conversion)");
  }
}

class MethodActionGenerator implements ActionGenerator {
  @override
  final String name;
  @override
  final DartType type;

  @visibleForTesting
  MethodActionGenerator({@required this.name, @required this.type});

  MethodActionGenerator.fromElement(FieldElement element)
      : name = element.type.getDisplayString(withNullability: false),
        type = element.type;

  String get methodName => 'extract$name';

  @override
  String get entryType => type.getDisplayString(withNullability: false);

  @override
  Code get toAction =>
      Code('GetTag<$entryType>(${entryType}Name, $methodName)');
}
