import 'dart:collection';

import 'package:generator/src/info/class_info.dart';
import 'package:source_gen/source_gen.dart';

import 'method_info.dart';

class Symtable {
  LinkedHashMap<String, ClassInfo> _classes;
  Map<ClassInfo, Iterable<ClassInfo>> _subclasses;
  final Iterable<MethodInfo> methods;

  bool hasClass(name) => _classes.containsKey(name);

  ClassInfo classNamed(name) => _classes[name];

  MethodInfo methodReturning(String desiredType) =>
      methods.firstWhere((m) => m.typeName == desiredType);

  Iterable<ClassInfo> subclassesOf(ClassInfo info) {
    if (!_subclasses.containsKey(info)) {
      _subclasses[info] = _classes.values
          .where((ClassInfo c) => c.type.superclass == info.type)
          .toList();
    }
    return _subclasses[info];
  }

  // BuiltList<MethodInfo> get
  factory Symtable.fromLibrary(LibraryReader library) {
    final classList = {for (var c in library.classes) ClassInfo.fromElement(c)};
    final classMap = {for (var info in classList) info.typeName: info};
    final methodList = classList
        .map((c) => c.method)
        .where((c) => c != null)
        .toList(growable: false);
    methodList.sort((a, b) => a.name.compareTo(b.name));
    return Symtable._(classMap, {}, methodList);
  }

  Symtable._(this._classes, this._subclasses, this.methods);
}
