// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_source_gen.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FieldSourceGen extends FieldSourceGen {
  @override
  final FieldEntry field;
  String __vardecl;
  String __initializer;

  factory _$FieldSourceGen([void Function(FieldSourceGenBuilder) updates]) =>
      (new FieldSourceGenBuilder()..update(updates)).build();

  _$FieldSourceGen._({this.field}) : super._() {
    if (field == null) {
      throw new BuiltValueNullFieldError('FieldSourceGen', 'field');
    }
  }

  @override
  String get vardecl => __vardecl ??= super.vardecl;

  @override
  String get initializer => __initializer ??= super.initializer;

  @override
  FieldSourceGen rebuild(void Function(FieldSourceGenBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FieldSourceGenBuilder toBuilder() =>
      new FieldSourceGenBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FieldSourceGen && field == other.field;
  }

  @override
  int get hashCode {
    return $jf($jc(0, field.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FieldSourceGen')..add('field', field))
        .toString();
  }
}

class FieldSourceGenBuilder
    implements Builder<FieldSourceGen, FieldSourceGenBuilder> {
  _$FieldSourceGen _$v;

  FieldEntryBuilder _field;
  FieldEntryBuilder get field => _$this._field ??= new FieldEntryBuilder();
  set field(FieldEntryBuilder field) => _$this._field = field;

  FieldSourceGenBuilder();

  FieldSourceGenBuilder get _$this {
    if (_$v != null) {
      _field = _$v.field?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FieldSourceGen other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FieldSourceGen;
  }

  @override
  void update(void Function(FieldSourceGenBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FieldSourceGen build() {
    _$FieldSourceGen _$result;
    try {
      _$result = _$v ?? new _$FieldSourceGen._(field: field.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'field';
        field.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'FieldSourceGen', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
