import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';
import 'package:runtime/annotations.dart';

T _getAnnotation<T>(Element element) =>
    _hasAnnotation<T>(element) ? element.metadata.whereType<T>().first : null;
bool _hasAnnotation<T>(Element element) =>
    element.metadata != null && element.metadata.whereType<T>().isNotEmpty;

class ClassEntry {
  final Tag annotation;
  final Iterable<FieldEntry> fields;
  final DartType type;
  final prefix = 'extract';

  @visibleForTesting
  ClassEntry(
      {@required this.annotation, @required this.type, @required this.fields});

  factory ClassEntry.fromElement(ClassElement element) {
    assert(_hasAnnotation<Tag>(element), '@Tag required');
    final annotation = _getAnnotation<Tag>(element);
    final type = element.thisType;
    final fields = element.fields.map((f) => FieldEntry.fromElement(f));
    return ClassEntry(annotation: annotation, type: type, fields: fields);
  }

  Method get toMethod => Method((b) => b
    ..name = '$prefix$typeName'
    ..body = Block.of([parseCall, returnCtor])
    ..modifier = MethodModifier.async
    ..requiredParameters.add(parameter)
    ..returns = refer('Future<$typeName>'));

  Parameter get parameter => Parameter((b) => b
    ..name = 'events'
    ..type = Reference('StreamQueue<XmlEvent>'));

  @visibleForTesting
  Code get parseCall {
    final entryVar = ReCase(typeName).pascalCase;
    return Code(
        "final $entryVar = await pr.parse(events, '${annotation.tag}' [$actions])");
  }

  String get actions => fields.map((f) => f.toAction).join(',\n');

  @visibleForTesting
  Code get returnCtor => Code('''return $typeName();''');

  String get typeName => type.getDisplayString(withNullability: false);

  String get toSource => DartEmitter().visitMethod(toMethod).toString();
}

abstract class FieldEntry {
  String get name;
  DartType get type;

  factory FieldEntry.fromElement(FieldElement element) =>
      element.type.isDartCoreObject
          ? AttributeFieldEntry.fromElement(
              element, _getAnnotation<Attribute>(element))
          : TagFieldEntry.fromElement(element);

  Code get toAction;

  String get entryType;
}

class AttributeFieldEntry implements FieldEntry {
  final Attribute annotation;
  @override
  final String name;
  @override
  final DartType type;
  final String trueIfEquals;
  final RegExp trueIfMatches;

  @visibleForTesting
  AttributeFieldEntry(
      {this.annotation,
      this.name,
      this.type,
      this.trueIfEquals,
      this.trueIfMatches});

  AttributeFieldEntry.fromElement(FieldElement element, [this.annotation])
      : name = element.getDisplayString(withNullability: false),
        type = element.type,
        trueIfEquals = annotation?.equals,
        trueIfMatches = annotation?.matches;

  String get attribute =>
      annotation != null ? (annotation.attribute ?? name) : null;

  /// The child tag to use, or null if using the parent tag's attribute
  String get tag => annotation?.tag;

  @override
  Code get toAction => Code("GetAttr<$entryType>('$attribute')");

  @override
  String get entryType => type.getDisplayString(withNullability: false);
}

class TagFieldEntry implements FieldEntry {
  @override
  final String name;
  @override
  final DartType type;

  @visibleForTesting
  TagFieldEntry({@required this.name, @required this.type});

  TagFieldEntry.fromElement(FieldElement element)
      : name = element.getDisplayString(withNullability: false),
        type = element.type;

  @override
  Code get toAction => Code("GetTag<$entryType>('---tag name---', events)");

  @override
  String get entryType => type.getDisplayString(withNullability: false);
}

/* 
Code _attributeConverter(DartType type, [FieldEntry entry]) {
  if (type.isDartCoreBool) {
    if (entry?.trueIfMatches != null) {
      return Code('ifMatches(${entry.trueIfMatches})');
    }
    if (entry?.trueIfEquals != null) {
      return Code('ifEquals(${entry.trueIfEquals})');
    }
    // else
    throw AssertionError('Bool requires either a string or regexp to match');
  }
  if (type.isDartCoreDouble) return Code('toDouble)');
  if (type.isDartCoreInt) return Code('toInt');
  return null;
}
*/
