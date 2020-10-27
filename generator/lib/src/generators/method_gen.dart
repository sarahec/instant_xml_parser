library parse_generator;

import 'package:code_builder/code_builder.dart';
import 'package:generator/src/info/field_info.dart';
import 'package:generator/src/info/symtable.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '../import_uris.dart' as uri;
import '../info/method_info.dart';
import 'field_gen.dart';

class MethodGenerator {
  final MethodInfo method;
  final Symtable symtable;
  final Iterable<FieldInfo> fields;
  final Logger _log = Logger('MethodGenerator');

  MethodGenerator(this.method, this.symtable)
      : fields = method.fields(symtable);

  String get constructor {
    final foundCtor = method.classInfo.constructor;
    if (foundCtor == null) {
      _log.warning(
          'No constructor found for ${method.typeName}, generating empty constructor call');
      return '${method.typeName}()';
    }

    final paramList = [
      for (var p in foundCtor.parameters)
        p.isNamed ? '${p.name}: ${p.name}' : p.name
    ];
    final params = paramList.join(',') ?? '';

    return '${method.typeName}($params)';
  }

  String get attributesBlock => [
        for (var f in fields.where((f) => f.isAttributeField))
          AttributeFieldGenerator(f, method, symtable).toAction
      ].join('\n');

  String get textExtractionBlock => [
        for (var f in fields.where((f) => f.isXmlTextField))
          TextFieldGenerator(f, method, symtable).toAction
      ].join('\n');

  Iterable<TagFieldGenerator> get childFieldGenerators => [
        for (var f in fields.where((f) => f.isChildField))
          TagFieldGenerator(f, method, symtable)
      ];

  String get startBlock => '''
      final  ${method.startVar} = 
        await pr.startOf(events, name: ${method.classInfo.constantName}, failOnMismatch: true);
      if (${method.startVar} == null) return null;''';

  String get endBlock => 'await pr.endOf(events, ${method.startVar});';

  @visibleForTesting
  Block get methodBody {
    final cgen = childFieldGenerators;
    final vars = [for (var c in cgen) c.vardecl].join('\n');
    final cases = [for (var c in cgen) c.toAction].join('\n');

    final childBlock = cgen.isEmpty
        ? ''
        : '''
      $vars
      var probe = await pr.startOf(events, parent: ${method.startVar});
      while (probe != null) {
        switch (probe.qualifiedName) {
          $cases
        default:
          await pr.logUnknown(probe, ${method.classInfo.constantName});
          await pr.consume(events, 1);
      }
      probe = await pr.startOf(events, parent: ${method.startVar});
    }''';

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
    ..name = method.name
    ..body = methodBody
    ..modifier = MethodModifier.async
    ..requiredParameters.addAll([
      Parameter((b) => b
        ..name = 'events'
        ..type = TypeReference((b) => b
          ..symbol = 'StreamQueue'
          ..url = uri.AsyncLibrary
          ..isNullable = false
          ..types.add(TypeReference((b) => b
            ..symbol = 'XmlEvent'
            ..url = uri.XMLEventsLibrary
            ..isNullable = false)))),
      Parameter((b) => b
        ..name = 'pr'
        ..type = TypeReference((b) => b
          ..symbol = 'ParserRuntime'
          ..url = uri.ParserRuntime
          ..isNullable = false))
    ])
    ..returns = TypeReference((b) => b // Future<SomeType>
      ..symbol = 'Future'
      ..isNullable = false
      ..url = uri.AsyncCoreLibrary
      ..types.add(TypeReference((b) => b
            ..symbol = method.typeName
            ..isNullable = false
          /* ..url = SourceLibrary */))));

  @visibleForTesting
  String get toSource => DartEmitter().visitMethod(toMethod).toString();
}
