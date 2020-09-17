import 'package:built_value/built_value.dart';
import 'package:generator/src/source_gen/converter_gen.dart';
import 'package:generator/src/symtable/field_entry.dart';

part 'field_source_gen.g.dart';

abstract class FieldSourceGen
    implements Built<FieldSourceGen, FieldSourceGenBuilder> {
  FieldEntry get entry;

  @memoized
  String get vardecl =>
      'var ${entry.name} ${entry.initVar ? initializer : ""};';

  @memoized
  String get initializer =>
      '= namedAttribute(element, \'{$entry.attribute}\', ${converterFor(entry)})';

  FieldSourceGen._();
  factory FieldSourceGen([void Function(FieldSourceGenBuilder) updates]) =
      _$FieldSourceGen;
}
