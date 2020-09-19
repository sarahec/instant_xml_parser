import 'package:built_value/built_value.dart';
import 'package:generator/src/source_gen/converter_gen.dart';
import 'package:generator/src/symtable/field_entry.dart';

part 'field_source_gen.g.dart';

abstract class FieldSourceGen
    implements Built<FieldSourceGen, FieldSourceGenBuilder> {
  FieldEntry get field;

  @memoized
  String get vardecl =>
      'var ${field.name} ${field.initVar ? initializer : ""};';

  @memoized
  String get initializer =>
      '= namedAttribute(element, \'{$field.attribute}\', ${converterFor(field)})';

  FieldSourceGen._();
  factory FieldSourceGen([void Function(FieldSourceGenBuilder) updates]) =
      _$FieldSourceGen;

  factory FieldSourceGen.fromField(FieldEntry fieldEntry) =>
      FieldSourceGen((b) => b..field = fieldEntry.toBuilder());
}
