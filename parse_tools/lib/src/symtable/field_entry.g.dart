// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FieldEntry extends FieldEntry {
  @override
  final String tagName;
  @override
  final String attributeName;
  @override
  final String name;
  @override
  final String methodName;
  @override
  final DartType type;

  factory _$FieldEntry([void Function(FieldEntryBuilder) updates]) =>
      (new FieldEntryBuilder()..update(updates)).build();

  _$FieldEntry._(
      {this.tagName, this.attributeName, this.name, this.methodName, this.type})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('FieldEntry', 'name');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('FieldEntry', 'type');
    }
  }

  @override
  FieldEntry rebuild(void Function(FieldEntryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FieldEntryBuilder toBuilder() => new FieldEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FieldEntry &&
        tagName == other.tagName &&
        attributeName == other.attributeName &&
        name == other.name &&
        methodName == other.methodName &&
        type == other.type;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, tagName.hashCode), attributeName.hashCode),
                name.hashCode),
            methodName.hashCode),
        type.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FieldEntry')
          ..add('tagName', tagName)
          ..add('attributeName', attributeName)
          ..add('name', name)
          ..add('methodName', methodName)
          ..add('type', type))
        .toString();
  }
}

class FieldEntryBuilder implements Builder<FieldEntry, FieldEntryBuilder> {
  _$FieldEntry _$v;

  String _tagName;
  String get tagName => _$this._tagName;
  set tagName(String tagName) => _$this._tagName = tagName;

  String _attributeName;
  String get attributeName => _$this._attributeName;
  set attributeName(String attributeName) =>
      _$this._attributeName = attributeName;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _methodName;
  String get methodName => _$this._methodName;
  set methodName(String methodName) => _$this._methodName = methodName;

  DartType _type;
  DartType get type => _$this._type;
  set type(DartType type) => _$this._type = type;

  FieldEntryBuilder();

  FieldEntryBuilder get _$this {
    if (_$v != null) {
      _tagName = _$v.tagName;
      _attributeName = _$v.attributeName;
      _name = _$v.name;
      _methodName = _$v.methodName;
      _type = _$v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FieldEntry other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FieldEntry;
  }

  @override
  void update(void Function(FieldEntryBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FieldEntry build() {
    final _$result = _$v ??
        new _$FieldEntry._(
            tagName: tagName,
            attributeName: attributeName,
            name: name,
            methodName: methodName,
            type: type);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
