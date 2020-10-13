// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FieldInfo extends FieldInfo {
  @override
  final FieldElement element;
  String __attributeName;
  bool __isXmlTextField;
  String __name;
  DartType __type;
  String __typeName;

  factory _$FieldInfo([void Function(FieldInfoBuilder) updates]) =>
      (new FieldInfoBuilder()..update(updates)).build();

  _$FieldInfo._({this.element}) : super._() {
    if (element == null) {
      throw new BuiltValueNullFieldError('FieldInfo', 'element');
    }
  }

  @override
  String get attributeName => __attributeName ??= super.attributeName;

  @override
  bool get isXmlTextField => __isXmlTextField ??= super.isXmlTextField;

  @override
  String get name => __name ??= super.name;

  @override
  DartType get type => __type ??= super.type;

  @override
  String get typeName => __typeName ??= super.typeName;

  @override
  FieldInfo rebuild(void Function(FieldInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FieldInfoBuilder toBuilder() => new FieldInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FieldInfo && element == other.element;
  }

  @override
  int get hashCode {
    return $jf($jc(0, element.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FieldInfo')..add('element', element))
        .toString();
  }
}

class FieldInfoBuilder implements Builder<FieldInfo, FieldInfoBuilder> {
  _$FieldInfo _$v;

  FieldElement _element;
  FieldElement get element => _$this._element;
  set element(FieldElement element) => _$this._element = element;

  FieldInfoBuilder();

  FieldInfoBuilder get _$this {
    if (_$v != null) {
      _element = _$v.element;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FieldInfo other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FieldInfo;
  }

  @override
  void update(void Function(FieldInfoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FieldInfo build() {
    final _$result = _$v ?? new _$FieldInfo._(element: element);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
