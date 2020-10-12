// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'method_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MethodInfo extends MethodInfo {
  @override
  final ClassInfo classInfo;
  @override
  final Iterable<FieldInfo> fields;
  @override
  final String name;
  @override
  final String prefix;
  String __startVar;

  factory _$MethodInfo([void Function(MethodInfoBuilder) updates]) =>
      (new MethodInfoBuilder()..update(updates)).build();

  _$MethodInfo._({this.classInfo, this.fields, this.name, this.prefix})
      : super._() {
    if (classInfo == null) {
      throw new BuiltValueNullFieldError('MethodInfo', 'classInfo');
    }
    if (fields == null) {
      throw new BuiltValueNullFieldError('MethodInfo', 'fields');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('MethodInfo', 'name');
    }
    if (prefix == null) {
      throw new BuiltValueNullFieldError('MethodInfo', 'prefix');
    }
  }

  @override
  String get startVar => __startVar ??= super.startVar;

  @override
  MethodInfo rebuild(void Function(MethodInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MethodInfoBuilder toBuilder() => new MethodInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MethodInfo &&
        classInfo == other.classInfo &&
        fields == other.fields &&
        name == other.name &&
        prefix == other.prefix;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, classInfo.hashCode), fields.hashCode), name.hashCode),
        prefix.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MethodInfo')
          ..add('classInfo', classInfo)
          ..add('fields', fields)
          ..add('name', name)
          ..add('prefix', prefix))
        .toString();
  }
}

class MethodInfoBuilder implements Builder<MethodInfo, MethodInfoBuilder> {
  _$MethodInfo _$v;

  ClassInfoBuilder _classInfo;
  ClassInfoBuilder get classInfo =>
      _$this._classInfo ??= new ClassInfoBuilder();
  set classInfo(ClassInfoBuilder classInfo) => _$this._classInfo = classInfo;

  Iterable<FieldInfo> _fields;
  Iterable<FieldInfo> get fields => _$this._fields;
  set fields(Iterable<FieldInfo> fields) => _$this._fields = fields;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _prefix;
  String get prefix => _$this._prefix;
  set prefix(String prefix) => _$this._prefix = prefix;

  MethodInfoBuilder();

  MethodInfoBuilder get _$this {
    if (_$v != null) {
      _classInfo = _$v.classInfo?.toBuilder();
      _fields = _$v.fields;
      _name = _$v.name;
      _prefix = _$v.prefix;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MethodInfo other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$MethodInfo;
  }

  @override
  void update(void Function(MethodInfoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$MethodInfo build() {
    _$MethodInfo _$result;
    try {
      _$result = _$v ??
          new _$MethodInfo._(
              classInfo: classInfo.build(),
              fields: fields,
              name: name,
              prefix: prefix);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'classInfo';
        classInfo.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'MethodInfo', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
