library parse_generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';
import 'package:runtime/annotations.dart';

import 'actions.dart';
import 'annotation_reader.dart';
import 'import_uris.dart';

class MethodGenerator with AnnotationReader {
  final String tagName;
  final Iterable<ActionGenerator> fields;
  final ConstructorElement constructorElement;
  final DartType type;
  final prefix = 'extract'; // TODO Make this configurable

  MethodGenerator.fromElement(ClassElement element)
      : tagName = AnnotationReader.getAnnotation<tag>(element, 'value'),
        type = element.thisType,
        fields = element.fields.map((f) => ActionGenerator.fromElement(f)),
        constructorElement = element.constructors.first;

  String get constantName => typeName + 'Name';

  String get constantValue => tagName;

  String get entryVar => 'values';

  String get constructor => '$typeName($constructorParams)';

  String get constructorParams => constructorElement == null
      ? ''
      : constructorElement.parameters
          .map((p) => "$entryVar['${p.name}']")
          .join(',');

  @visibleForTesting
  Block get methodBody {
    final actions = fields.map((f) => f.toAction).join(',\n');
    return Block.of([
      Code(
          'final $entryVar = await pr.parse(events, $constantName, [$actions]);'),
      Code('return $constructor;')
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
}
