library parse_generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';
import 'package:runtime/annotations.dart';
import 'package:source_gen/source_gen.dart';

const AsyncCoreLibrary = 'dart:async';
const AsyncLibrary = 'package:async/async.dart';
const ParserRuntime = 'package:runtime/runtime.dart';
const XMLEventsLibrary = 'package:xml/xml_events.dart';

T _getAnnotation<T>(Element element) =>
    _hasAnnotation<T>(element) ? element.metadata.whereType<T>().first : null;
bool _hasAnnotation<T>(Element element) =>
    element.metadata != null && element.metadata.whereType<T>().isNotEmpty;

class LibraryGenerator {
  final Iterable<MethodGenerator> classEntries;
  final AssetId sourceAsset;

  LibraryGenerator.fromLibrary(LibraryReader library, this.sourceAsset)
      : classEntries = library
            .annotatedWith(TypeChecker.fromRuntime(Tag))
            .map((e) => MethodGenerator.fromElement(e.element));

  Iterable<Field> get constants => classEntries.map((c) => Field((b) => b
    ..name = c.constantName
    ..assignment = Code("'${c.constantValue}'")
    ..modifier = FieldModifier.final$));

  Class get classWrapper => Class((b) => b
    ..name = 'Parser' // BUGBUG Add name of source file, uing Pascal case
    ..fields.addAll(constants)
    ..methods.addAll(methods)
    ..methods.add(Method((b) => b
      ..name = 'pr'
      ..type = MethodType.getter
      ..lambda = true
      ..returns = Reference('ParserRuntime', ParserRuntime)
      ..body = Code('ParserRuntime()'))));

  List<Directive> get directives => [
        Directive.import(ParserRuntime),
        Directive.import(sourceAsset.pathSegments.last)
      ];
  List<Method> get methods => classEntries.map((c) => c.toMethod).toList();

  Library get toCode => Library((b) => b
    ..directives.addAll(directives)
    ..body.add(classWrapper));

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

  // Future<SomeType> extractSomeType(StreamQueue<XmlEvent> events) async
  Method get toMethod => Method((b) => b
    ..name = '$prefix$typeName'
    ..body = methodBody
    ..modifier = MethodModifier.async
    ..requiredParameters.add(Parameter((b) => b
      ..name = 'events'
      ..type = TypeReference((b) => b
        ..symbol = 'StreamQueue'
        ..url = AsyncLibrary
        ..isNullable = false
        ..types.add(TypeReference((b) => b
          ..symbol = 'XmlEvent'
          ..url = XMLEventsLibrary
          ..isNullable = false)))))
    ..returns = TypeReference((b) => b // Future<SomeType>
      ..symbol = 'Future'
      ..isNullable = false
      ..url = AsyncCoreLibrary
      // BUGBUG Need to get reference to source lib?
      ..types.add(TypeReference((b) => b
            ..symbol = typeName
            ..isNullable = false
          /* ..url = SourceLibrary */))));

  @visibleForTesting
  Block get methodBody {
    final entryVar = ReCase(typeName).camelCase;
    final actions = fields.map((f) => f.toAction).join(',\n');
    return Block.of([
      Code(
          'final $entryVar = await pr.parse(events, $constantName, [$actions]);'),
      Code('''return $typeName();''')
    ]);
  }

  String get constantName => typeName + 'TagName';

  String get constantValue => annotation?.tag ?? typeName;

  String get typeName => type.getDisplayString(withNullability: false);

  @visibleForTesting
  String get toSource => DartEmitter().visitMethod(toMethod).toString();
}

abstract class ActionGenerator {
  String get name;
  DartType get type;

  factory ActionGenerator.fromElement(FieldElement element) =>
      _isPrimitive(element.type)
          ? AttributeActionGenerator.fromElement(
              element, _getAnnotation<Attribute>(element))
          : MethodActionGenerator.fromElement(element);

  Code get toAction;

  String get entryType;

  static bool _isPrimitive(DartType type) => (type.isDartCoreBool ||
      type.isDartCoreDouble ||
      type.isDartCoreInt ||
      type.isDartCoreString);

  // TODO Also handle lists/iterables of primitives
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
