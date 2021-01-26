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
  Iterable<Object> serialize(Serializers serializers, ClassInfo object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'element',
      serializers.serialize(object.element,
          specifiedType: const FullType(ClassElement)),
      'type',
      serializers.serialize(object.type,
          specifiedType: const FullType(InterfaceType)),
    ];
    if (object.subclasses != null) {
      result
        ..add('subclasses')
        ..add(serializers.serialize(object.subclasses,
            specifiedType:
                const FullType(Iterable, const [const FullType(DartType)])));
    }
    return result;
  }

  @override
  ClassInfo deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ClassInfoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'element':
          result.element = serializers.deserialize(value,
              specifiedType: const FullType(ClassElement)) as ClassElement;
          break;
        case 'subclasses':
          result.subclasses = serializers.deserialize(value,
                  specifiedType: const FullType(
                      Iterable, const [const FullType(DartType)]))
              as Iterable<DartType>;
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
  final Iterable<DartType> subclasses;
  @override
  final InterfaceType type;
  ConstructorElement __constructor;
  MethodInfo __method;
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
  ConstructorElement get constructor => __constructor ??= super.constructor;

  @override
  MethodInfo get method => __method ??= super.method;

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
