import 'package:generator/src/symtable/field_entry.dart';

String converterFor(FieldEntry entry) {
  final type = entry.type;
  if (type.isDartCoreBool) {
    if (entry.trueIfMatches != null) return 'ifMatches(${entry.trueIfMatches})';
    if (entry.trueIfEquals != null) return 'ifEquals(${entry.trueIfEquals})';
    // else
    throw AssertionError('Bool requires either a string or regexp to match');
  }
  if (type.isDartCoreDouble) return 'toDouble';
  if (type.isDartCoreInt) return 'toInt';
  return 'null'; // TODO Log unknown type
}
