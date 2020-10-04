library parse_generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';
import 'package:runtime/annotations.dart';

import 'actions.dart';
import 'common.dart';

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
  String get constantName => typeName + 'TagName';

  String get constantValue => annotation?.tag ?? typeName;

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
      ..types.add(TypeReference((b) => b
            ..symbol = typeName
            ..isNullable = false
          /* ..url = SourceLibrary */))));

  @visibleForTesting
  String get toSource => DartEmitter().visitMethod(toMethod).toString();

  String get typeName => type.getDisplayString(withNullability: false);

  static T _getAnnotation<T>(Element element) =>
      _hasAnnotation<T>(element) ? element.metadata.whereType<T>().first : null;
  static bool _hasAnnotation<T>(Element element) =>
      element.metadata != null && element.metadata.whereType<T>().isNotEmpty;
}
