// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ClassInfo> _$classInfoSerializer = new _$ClassInfoSerializer();

class _$ClassInfoSerializer implements StructuredSerializer<ClassInfo> {
  @override
  final Iterable<Type> types = const [ClassInfo, _$ClassInfo];
  @override
  final String wireName = 'ClassInfo';

  @override
  Iterable<Object?> serialize(Serializers serializers, ClassInfo object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'element',
      serializers.serialize(object.element,
          specifiedType: const FullType(ClassElement)),
      'type',
      serializers.serialize(object.type,
          specifiedType: const FullType(InterfaceType)),
    ];

    return result;
  }

  @override
  ClassInfo deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ClassInfoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'element':
          result.element = serializers.deserialize(value,
              specifiedType: const FullType(ClassElement)) as ClassElement;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(InterfaceType)) as InterfaceType;
          break;
      }
    }

    return result.build();
  }
}

class _$ClassInfo extends ClassInfo {
  @override
  final ClassElement element;
  @override
  final InterfaceType type;
  ConstructorElement? __constructor;
  MethodInfo? __method;
  bool ___method = false;
  String? __typeName;

  factory _$ClassInfo([void Function(ClassInfoBuilder)? updates]) =>
      (new ClassInfoBuilder()..update(updates)).build();

  _$ClassInfo._({required this.element, required this.type}) : super._() {
    BuiltValueNullFieldError.checkNotNull(element, 'ClassInfo', 'element');
    BuiltValueNullFieldError.checkNotNull(type, 'ClassInfo', 'type');
  }

  @override
  ConstructorElement get constructor => __constructor ??= super.constructor;

  @override
  MethodInfo? get method {
    if (!___method) {
      __method = super.method;
      ___method = true;
    }
    return __method;
  }

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
    return other is ClassInfo && element == other.element && type == other.type;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, element.hashCode), type.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ClassInfo')
          ..add('element', element)
          ..add('type', type))
        .toString();
  }
}

class ClassInfoBuilder implements Builder<ClassInfo, ClassInfoBuilder> {
  _$ClassInfo? _$v;

  ClassElement? _element;
  ClassElement? get element => _$this._element;
  set element(ClassElement? element) => _$this._element = element;

  InterfaceType? _type;
  InterfaceType? get type => _$this._type;
  set type(InterfaceType? type) => _$this._type = type;

  ClassInfoBuilder();

  ClassInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _element = $v.element;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClassInfo other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ClassInfo;
  }

  @override
  void update(void Function(ClassInfoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ClassInfo build() {
    final _$result = _$v ??
        new _$ClassInfo._(
            element: BuiltValueNullFieldError.checkNotNull(
                element, 'ClassInfo', 'element'),
            type: BuiltValueNullFieldError.checkNotNull(
                type, 'ClassInfo', 'type'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
