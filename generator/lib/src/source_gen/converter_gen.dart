import 'package:analyzer/dart/element/type.dart';
import 'package:generator/src/symtable/field_entry.dart';

String converterFor(FieldEntry entry) {
  final type = entry.type;
  if (type.isDartCoreBool) {
    if (entry.trueIfMatches != null) {
      return '(s) => ${entry.trueIfMatches}.hasMatch(s)';
    } else if (entry.trueIfEquals != null) {
      return '(s) => ${entry.trueIfEquals} == s';
    } else {
      throw AssertionError('Bool requires either a string or regexp to match');
    }
  } else if (type.isDartCoreDouble) {
    return '(s) => double.parse(s)';
  } else if (type.isDartCoreInt) {
    return '(s) => int.parse(s)';
  }
  return 'null'; // TODO Log unknown type
}
