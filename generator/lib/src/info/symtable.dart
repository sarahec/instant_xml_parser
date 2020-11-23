import 'dart:collection';

import 'package:analyzer/dart/element/type.dart';
import 'package:generator/src/info/class_info.dart';

import 'library_info.dart';
import 'method_info.dart';

class Symtable {
  LinkedHashMap<String, ClassInfo> _classes;
  Map<DartType, Iterable<ClassInfo>> _subclasses;
  final Iterable<MethodInfo> methods;

  bool hasClass(name) => _classes.containsKey(name);

  ClassInfo classNamed(name) => _classes[name];

  ClassInfo classForType(DartType t) =>
      _classes.values.firstWhere((v) => v.type == t, orElse: () => null);

  Iterable<MethodInfo> methodsReturning(DartType desiredType,
      [allowSubtypes = true]) {
    var result = methods.where((m) => m.type == desiredType);
    if (result.isEmpty && allowSubtypes) {
      result = subclassesOf(desiredType)?.map((c) => c.method);
    }
    return (result == null || result.isEmpty) ? null : result;
  }

  Iterable<ClassInfo> subclassesOf(DartType type) {
    if (!_subclasses.containsKey(type)) {
      _subclasses[type] = _classes.values
          .where((ClassInfo c) => c.type.superclass == type)
          .toList();
    }
    return _subclasses[type];
  }

  // BuiltList<MethodInfo> get
  factory Symtable.fromLibraryInfo(LibraryInfo library) {
    final classMap = {for (var info in library.classes) info.typeName: info};
    final methodList = library.classes
        .map((c) => c.method)
        .where((c) => c != null)
        .toList(growable: false);
    methodList.sort((a, b) => a.name.compareTo(b.name));
    return Symtable._(classMap, {}, methodList);
  }

  Symtable._(this._classes, this._subclasses, this.methods);
}
