import 'package:generator/src/symtable/field_entry.dart';

class FieldSourceGen {
  final FieldEntry entry;

  String get vardecl =>
      'var ${entry.name} ${entry.initVar ? initializer : ""};';

  String get initializer =>
      "= namedAttribute(element, '{$entry.attribute}'${_converter()})";

  String _converter([String prefix = ', converter: ']) {
    if (entry.type.isDartCoreBool) {
      if (entry.trueIfMatches != null) {
        return '$prefix ifMatches(${entry.trueIfMatches})';
      }
      if (entry.trueIfEquals != null) {
        return '$prefix ifEquals(${entry.trueIfEquals})';
      }
      // else
      throw AssertionError('Bool requires either a string or regexp to match');
    }
    if (entry.type.isDartCoreDouble) return '$prefix toDouble';
    if (entry.type.isDartCoreInt) return '$prefix toInt';
    return '';
  }

  FieldSourceGen(this.entry);
}
