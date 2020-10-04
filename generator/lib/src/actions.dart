library parse_generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';
import 'package:runtime/annotations.dart';

abstract class ActionGenerator {
  factory ActionGenerator.fromElement(FieldElement element) =>
      _isPrimitive(element.type)
          ? AttributeActionGenerator.fromElement(
              element, _getAnnotation<Attribute>(element))
          : MethodActionGenerator.fromElement(element);
  String get entryType;

  String get name;

  Code get toAction;

  DartType get type;

  static T _getAnnotation<T>(Element element) =>
      _hasAnnotation<T>(element) ? element.metadata.whereType<T>().first : null;

  // TODO Also handle lists/iterables of primitives

  static bool _hasAnnotation<T>(Element element) =>
      element.metadata != null && element.metadata.whereType<T>().isNotEmpty;
  static bool _isPrimitive(DartType type) => (type.isDartCoreBool ||
      type.isDartCoreDouble ||
      type.isDartCoreInt ||
      type.isDartCoreString);
}

class AttributeActionGenerator implements ActionGenerator {
  final Attribute annotation;
  @override
  final String name;
  @override
  final DartType type;
  final String trueIfEquals;
  final RegExp trueIfMatches;

  @visibleForTesting
  AttributeActionGenerator(
      {this.annotation,
      this.name,
      this.type,
      this.trueIfEquals,
      this.trueIfMatches});

  AttributeActionGenerator.fromElement(FieldElement element, [this.annotation])
      : name = element.name,
        type = element.type,
        trueIfEquals = annotation?.equals,
        trueIfMatches = annotation?.matches;

  String get attribute => annotation?.attribute ?? name;

  @override
  String get entryType => type.getDisplayString(withNullability: false);

  /// The child tag to use, or null if using the parent tag's attribute
  String get tag => annotation?.tag;

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
      : name = element.getDisplayString(withNullability: false),
        type = element.type;

  @override
  String get entryType => type.getDisplayString(withNullability: false);

  @override
  Code get toAction => Code('GetTag<$entryType>(${entryType}TagName, events)');
}
