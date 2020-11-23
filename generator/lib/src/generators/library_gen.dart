library parse_generator;

import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:generator/src/import_uris.dart';
import 'package:generator/src/info/library_info.dart';
import 'package:generator/src/info/symtable.dart';

import 'method_gen.dart';

class LibraryGenerator {
  final LibraryInfo info;
  final AssetId sourceAsset;
  final Symtable symtable;

  var _importUris;

  LibraryGenerator(this.info, this.sourceAsset)
      : symtable = Symtable.fromLibraryInfo(info);

  Iterable<Method> get methods => [
        for (var method in symtable.methods)
          MethodGenerator(method, symtable).toMethod
      ];

  Iterable<String> get importUris {
    if (_importUris == null) {
      _importUris = <String>[];
      _importUris.add(sourceAsset.pathSegments.last);
      _importUris.addAll(info.importUris.where((s) =>
          !(s.contains('runtime/annotations.dart') || s.contains('/src/'))));
      _importUris.addAll([Logging, Runtime]);
    }
    return _importUris;
  }

  Iterable<Field> get constants => symtable.methods.map((c) => Field((b) => b
    ..name = c.classInfo.constantName
    ..assignment = Code("'${c.classInfo.tagName}'")
    ..modifier = FieldModifier.constant));

  Library get toCode => Library((b) => b
    ..directives.addAll(importUris.map((i) => Directive.import(i)))
    ..body.addAll(constants)
    ..body.add(Code("final _log = Logger('parser');"))
    ..body.addAll(methods));
}
