library parse_gen.field_entry;

import 'package:analyzer/dart/element/type.dart';
import 'package:built_value/built_value.dart';

part 'field_entry.g.dart';

abstract class FieldEntry implements Built<FieldEntry, FieldEntryBuilder> {
  @nullable
  String get tagName;

  @nullable
  String get attributeName;

  String get name;

  @nullable
  String get methodName;

  DartType get type;

  // TODO add attribute match value or function

  FieldEntry._();
  factory FieldEntry([void Function(FieldEntryBuilder) updates]) = _$FieldEntry;
}

// Sources of field values:
// - method call (needs tag for lookahead)
// - attribute on start tag (null)
// - attribute on specific tag
// - attribute matches value
// - repeated method calls
// - repeated attribute selection
// - CDATA on tag

// Special tag actions
// - skip
// - collect contents
