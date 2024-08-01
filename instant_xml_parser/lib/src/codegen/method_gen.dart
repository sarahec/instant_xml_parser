// Copyright 2020, 2024 Google LLC and contributors
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

import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';

import '../import_uris.dart' as uri;
import '../info/class_info.dart';
import '../info/method_info.dart';
import 'field_gen.dart';

class MethodGenerator {
  final ClassElement method;
  final LibraryReader symtable;
  final Iterable<CommonElement> commonElements;
  final Logger _log = Logger('MethodGenerator');

  MethodGenerator(this.method, this.symtable)
      : commonElements = method.commonElements;

  String get attributesBlock => [
        for (var f in commonElements.where((f) => f.field.isAttributeField))
          AttributeFieldGenerator(f, method, symtable).toAction
      ].join('\n');

  Iterable<TagFieldGenerator> get childFieldGenerators => [
        for (var e in commonElements
            .where((f) => f.field.isChildField && !f.field.isCustom))
          TagFieldGenerator(e, method, symtable)
      ];

  String get constructor {
    if (!method.hasConstructor) {
      _log.warning(
          'No constructor found for ${method.typeName}, generating empty constructor call');
      return '${method.typeName}()';
    }
    final foundCtor = method.constructor;
    final paramList = [
      for (var p in foundCtor.parameters)
        p.isNamed ? '${p.name}: ${p.name}' : p.name
    ];
    final params = paramList.join(',');

    return '${method.typeName}($params)';
  }

  String get endBlock => '''
    $resolveCustomClasses
    $resolveDeferredAttributes

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
        while (await events.scanTo(startTag(inside(${method.startVar})))) {
        final probe = await events.peek as XmlStartElementEvent;
        switch (probe.qualifiedName) {
          $cases
        default:
          probe.logUnknown(expected: ${method.constantName});
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

  String get resolveCustomClasses => [
        for (var f in commonElements.where(
            (f) => f.field.isChildField && f.field.isCustom && !f.field.isList))
          TagFieldGenerator(f, method, symtable).customCode
      ].join('\n');

  String get resolveDeferredAttributes => [
        for (var f in commonElements
            .where((f) => f.field.isAttributeField && f.field.isDeferred))
          AttributeFieldGenerator(f, method, symtable).resolveDeferred
      ].join('\n');

  String get startBlock => '''
      final found = await events.scanTo(startTag(named(${method.constantName}))); 
      if (!found) {
        throw MissingStartTag(${method.constantName});
      }
      final ${method.startVar} = await events.next as XmlStartElementEvent;
      _log.finest('in ${method.tagName}');
      ''';

  String get textExtractionBlock => [
        for (var f in commonElements.where((f) => f.field.isXmlTextField))
          TextFieldGenerator(f, method, symtable).toAction
      ].join('\n');

  Method get toMethod => Method((b) => b
    ..name = method.methodName
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
    ..returns = TypeReference((b) => b // Future<SomeType>
      ..symbol = 'Future'
      ..isNullable = false
      ..types.add(TypeReference((b) => b
        ..symbol = method.typeName
        ..isNullable = false))));

  @visibleForTesting
  String get toSource => DartEmitter().visitMethod(toMethod).toString();
}
