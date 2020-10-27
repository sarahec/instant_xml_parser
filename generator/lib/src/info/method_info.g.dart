// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'method_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MethodInfo extends MethodInfo {
  @override
  final ClassInfo classInfo;
  @override
  final String prefix;
  String __startVar;

  factory _$MethodInfo([void Function(MethodInfoBuilder) updates]) =>
      (new MethodInfoBuilder()..update(updates)).build();

  _$MethodInfo._({this.classInfo, this.prefix}) : super._() {
    if (classInfo == null) {
      throw new BuiltValueNullFieldError('MethodInfo', 'classInfo');
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
        prefix == other.prefix;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, classInfo.hashCode), prefix.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MethodInfo')
          ..add('classInfo', classInfo)
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

  String _prefix;
  String get prefix => _$this._prefix;
  set prefix(String prefix) => _$this._prefix = prefix;

  MethodInfoBuilder();

  MethodInfoBuilder get _$this {
    if (_$v != null) {
      _classInfo = _$v.classInfo?.toBuilder();
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
          new _$MethodInfo._(classInfo: classInfo.build(), prefix: prefix);
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
