library parse_generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';
import 'package:runtime/annotations.dart';
import 'package:source_gen/source_gen.dart';

T _getAnnotation<T>(Element element) =>
    _hasAnnotation<T>(element) ? element.metadata.whereType<T>().first : null;
bool _hasAnnotation<T>(Element element) =>
    element.metadata != null && element.metadata.whereType<T>().isNotEmpty;

class LibraryGenerator {
  final Iterable<MethodGenerator> classEntries;
  // TODO final String get sourcePath; // need to include source file

  LibraryGenerator.fromLibrary(LibraryReader library)
      : classEntries = library
            .annotatedWith(TypeChecker.fromRuntime(Tag))
            .map((e) => MethodGenerator.fromElement(e as ClassElement));

  Code get constants => Code(classEntries
      .map((MethodGenerator c) =>
          "const ${c.constantName} = '${c.constantValue}';")
      .join('\n'));

  Code get imports => Code('''
  import 'dart:async';
  import 'package:async/async.dart';
  import 'package:runtime/runtime.dart';
  import 'package:xml/xml_events.dart';

  import 'structures.dart';
  ''');

  List<Method> get methods => classEntries.map((c) => c.toMethod);

  Library get toCode =>
      Library((b) => b.body..addAll([imports, constants])..addAll(methods));

  String get toSource => DartEmitter().visitLibrary(toCode).toString();
}

class MethodGenerator {
  final Tag annotation;
  final Iterable<ActionGenerator> fields;
  final DartType type;
  final prefix = 'extract';

  @visibleForTesting
  MethodGenerator(
      {@required this.annotation, @required this.type, @required this.fields});

  factory MethodGenerator.fromElement(ClassElement element) {
    assert(_hasAnnotation<Tag>(element), '@Tag required');
    final annotation = _getAnnotation<Tag>(element);
    final type = element.thisType;
    final fields = element.fields.map((f) => ActionGenerator.fromElement(f));
    return MethodGenerator(annotation: annotation, type: type, fields: fields);
  }

  Method get toMethod => Method((b) => b
    ..name = '$prefix$typeName'
    ..body = methodBody
    ..modifier = MethodModifier.async
    ..requiredParameters.add(Parameter((b) => b
      ..name = 'events'
      ..type = Reference('StreamQueue<XmlEvent>')))
    ..returns = refer('Future<$typeName>'));

  @visibleForTesting
  Block get methodBody {
    final entryVar = ReCase(typeName).camelCase;
    final actions = fields.map((f) => f.toAction).join(',\n');
    return Block.of([
      Code(
          'final $entryVar = await pr.parse(events, $constantName, [$actions])'),
      Code('''return $typeName();''')
    ]);
  }

  String get constantName => typeName + 'TagName';

  String get constantValue => annotation.tag;

  String get typeName => type.getDisplayString(withNullability: false);

  @visibleForTesting
  String get toSource => DartEmitter().visitMethod(toMethod).toString();
}

abstract class ActionGenerator {
  String get name;
  DartType get type;

  factory ActionGenerator.fromElement(FieldElement element) =>
      element.type.isDartCoreObject
          ? AttributeActionGenerator.fromElement(
              element, _getAnnotation<Attribute>(element))
          : MethodActionGenerator.fromElement(element);

  Code get toAction;

  String get entryType;
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
      : name = element.getDisplayString(withNullability: false),
        type = element.type,
        trueIfEquals = annotation?.equals,
        trueIfMatches = annotation?.matches;

  String get attribute =>
      annotation != null ? (annotation.attribute ?? name) : null;

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
    return Code("GetAttr<$entryType>('$attribute $conversion')");
  }

  @override
  String get entryType => type.getDisplayString(withNullability: false);
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
  Code get toAction => Code('GetTag<$entryType>(${entryType}TagName, events)');

  @override
  String get entryType => type.getDisplayString(withNullability: false);
}
