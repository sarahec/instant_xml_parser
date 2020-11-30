// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
      final ${method.startVar} = await events.find(startTag(named(${method.classInfo.constantName}))) as XmlStartElementEvent; 
      if(${method.startVar} == null) {
        return optional ? null : Future.error(MissingStartTag(${method.classInfo.constantName}));
      }
      _log.fine('in ${method.classInfo.tagName}');
      ''';

  String get endBlock => '''
    _log.finest('consume ${method.classInfo.tagName}'); 
    await events.consume(inside(${method.startVar}));''';

  @visibleForTesting
  Block get methodBody {
    final cgen = childFieldGenerators;
    final vars = [for (var c in cgen) c.vardecl].join('\n');
    final cases = [for (var c in cgen) c.toAction].join('\n');

    final childBlock = cgen.isEmpty
        ? ''
        : '''
      $vars
        for (;;) {
        var probe = await events.find(startTag(inside(${method.startVar})), keepFound: true) as XmlStartElementEvent;
        if (probe == null) break;
        switch (probe.qualifiedName) {
          $cases
        default:
          probe.logUnknown(expected: ${method.classInfo.constantName});
          await events.next;
      }
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
            ..isNullable = false))))
    ])
    ..optionalParameters.add(Parameter((b) => b
      ..name = 'optional'
      ..named = true
      ..defaultTo = Code('true')))
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
