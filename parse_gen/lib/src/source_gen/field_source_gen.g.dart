// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_source_gen.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FieldSourceGen extends FieldSourceGen {
  @override
  final FieldEntry entry;
  String __vardecl;
  String __initializer;

  factory _$FieldSourceGen([void Function(FieldSourceGenBuilder) updates]) =>
      (new FieldSourceGenBuilder()..update(updates)).build();

  _$FieldSourceGen._({this.entry}) : super._() {
    if (entry == null) {
      throw new BuiltValueNullFieldError('FieldSourceGen', 'entry');
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
    return other is FieldSourceGen && entry == other.entry;
  }

  @override
  int get hashCode {
    return $jf($jc(0, entry.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FieldSourceGen')..add('entry', entry))
        .toString();
  }
}

class FieldSourceGenBuilder
    implements Builder<FieldSourceGen, FieldSourceGenBuilder> {
  _$FieldSourceGen _$v;

  FieldEntryBuilder _entry;
  FieldEntryBuilder get entry => _$this._entry ??= new FieldEntryBuilder();
  set entry(FieldEntryBuilder entry) => _$this._entry = entry;

  FieldSourceGenBuilder();

  FieldSourceGenBuilder get _$this {
    if (_$v != null) {
      _entry = _$v.entry?.toBuilder();
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
      _$result = _$v ?? new _$FieldSourceGen._(entry: entry.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'entry';
        entry.build();
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
