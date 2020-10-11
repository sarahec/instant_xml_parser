library parse_generator;

import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';

import 'fields.dart';
import 'import_uris.dart';
import 'method_info.dart';

class MethodGenerator {
  final MethodInfo info;
  final Iterable<FieldGenerator> fields;
  final ConstructorElement constructorElement;

  MethodGenerator.fromElement(ClassElement element, MethodInfo info)
      : info = info,
        fields = element.fields.map((f) => FieldGenerator.fromElement(f, info)),
        constructorElement = element.constructors.first;

  String get constructor {
    final params =
        constructorElement?.parameters?.map((p) => p.name)?.join(',') ?? '';
    return '${info.typeName}($params)';
  }

  String blockOf(Section section) => fields
      .where((f) => f.section == section)
      .map((f) => f.toAction)
      .join('\n');

  @visibleForTesting
  Block get methodBody {
    final startVar = '_${ReCase(info.typeName).camelCase}';
    final attributesBlock = blockOf(Section.attributesSection);
    final textExtractionBlock = blockOf(Section.textSection);

    final children = fields.where((f) => f.section == Section.childSection);
    final childVars =
        children.map((f) => (f as ChildGenerator).vardecl).join('\n');

    final childBlock = children.isEmpty
        ? ''
        : '''
      $childVars
      var probe = await _pr.startOf(events, parent: $startVar);
      while (probe != null) {
        switch (probe.qualifiedName) {
          ${blockOf(Section.childSection)}
        default:
          await _pr.logUnknown(probe, ${info.constantName});
      }
      await events.skip(1);
      probe = await _pr.startOf(events, parent: $startVar);
    }''';

    final startBlock = '''
      final  $startVar = 
        await _pr.startOf(events, name: ${info.constantName}, failOnMismatch: true);
      if ($startVar == null) return null;''';

    final endBlock = 'await _pr.endOf(events, $startVar);';

    return Block.of([
      startBlock,
      attributesBlock,
      textExtractionBlock,
      childBlock,
      endBlock,
      'return $constructor;'
    ].map((s) => Code(s)));
  }

  Method get toMethod => Method((b) => b
    ..name = info.name
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
            ..symbol = info.typeName
            ..isNullable = false
          /* ..url = SourceLibrary */))));

  @visibleForTesting
  String get toSource => DartEmitter().visitMethod(toMethod).toString();
}
