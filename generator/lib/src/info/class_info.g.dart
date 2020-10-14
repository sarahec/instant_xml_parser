// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ClassInfo extends ClassInfo {
  @override
  final ClassElement element;
  @override
  final Iterable<DartType> subclasses;
  @override
  final InterfaceType type;
  MethodInfo __method;
  ConstructorInfo __constructor;
  String __tagName;
  String __typeName;

  factory _$ClassInfo([void Function(ClassInfoBuilder) updates]) =>
      (new ClassInfoBuilder()..update(updates)).build();

  _$ClassInfo._({this.element, this.subclasses, this.type}) : super._() {
    if (element == null) {
      throw new BuiltValueNullFieldError('ClassInfo', 'element');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('ClassInfo', 'type');
    }
  }

  @override
  MethodInfo get method => __method ??= super.method;

  @override
  ConstructorInfo get constructor => __constructor ??= super.constructor;

  @override
  String get tagName => __tagName ??= super.tagName;

  @override
  String get typeName => __typeName ??= super.typeName;

  @override
  ClassInfo rebuild(void Function(ClassInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClassInfoBuilder toBuilder() => new ClassInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClassInfo &&
        element == other.element &&
        subclasses == other.subclasses &&
        type == other.type;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, element.hashCode), subclasses.hashCode), type.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ClassInfo')
          ..add('element', element)
          ..add('subclasses', subclasses)
          ..add('type', type))
        .toString();
  }
}

class ClassInfoBuilder implements Builder<ClassInfo, ClassInfoBuilder> {
  _$ClassInfo _$v;

  ClassElement _element;
  ClassElement get element => _$this._element;
  set element(ClassElement element) => _$this._element = element;

  Iterable<DartType> _subclasses;
  Iterable<DartType> get subclasses => _$this._subclasses;
  set subclasses(Iterable<DartType> subclasses) =>
      _$this._subclasses = subclasses;

  InterfaceType _type;
  InterfaceType get type => _$this._type;
  set type(InterfaceType type) => _$this._type = type;

  ClassInfoBuilder();

  ClassInfoBuilder get _$this {
    if (_$v != null) {
      _element = _$v.element;
      _subclasses = _$v.subclasses;
      _type = _$v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClassInfo other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ClassInfo;
  }

  @override
  void update(void Function(ClassInfoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ClassInfo build() {
    final _$result = _$v ??
        new _$ClassInfo._(element: element, subclasses: subclasses, type: type);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
