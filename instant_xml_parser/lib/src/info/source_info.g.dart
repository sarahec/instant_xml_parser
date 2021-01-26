// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SourceInfo> _$sourceInfoSerializer = new _$SourceInfoSerializer();

class _$SourceInfoSerializer implements StructuredSerializer<SourceInfo> {
  @override
  final Iterable<Type> types = const [SourceInfo, _$SourceInfo];
  @override
  final String wireName = 'SourceInfo';

  @override
  Iterable<Object> serialize(Serializers serializers, SourceInfo object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'classes',
      serializers.serialize(object.classes,
          specifiedType:
              const FullType(Iterable, const [const FullType(ClassInfo)])),
      'element',
      serializers.serialize(object.element,
          specifiedType: const FullType(LibraryElement)),
      'uri',
      serializers.serialize(object.uri, specifiedType: const FullType(Uri)),
    ];

    return result;
  }

  @override
  SourceInfo deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SourceInfoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'classes':
          result.classes = serializers.deserialize(value,
                  specifiedType: const FullType(
                      Iterable, const [const FullType(ClassInfo)]))
              as Iterable<ClassInfo>;
          break;
        case 'element':
          result.element = serializers.deserialize(value,
              specifiedType: const FullType(LibraryElement)) as LibraryElement;
          break;
        case 'uri':
          result.uri = serializers.deserialize(value,
              specifiedType: const FullType(Uri)) as Uri;
          break;
      }
    }

    return result.build();
  }
}

class _$SourceInfo extends SourceInfo {
  @override
  final Iterable<ClassInfo> classes;
  @override
  final LibraryElement element;
  @override
  final Uri uri;
  Iterable<String> __importUris;
  Iterable<MethodInfo> __methods;

  factory _$SourceInfo([void Function(SourceInfoBuilder) updates]) =>
      (new SourceInfoBuilder()..update(updates)).build();

  _$SourceInfo._({this.classes, this.element, this.uri}) : super._() {
    if (classes == null) {
      throw new BuiltValueNullFieldError('SourceInfo', 'classes');
    }
    if (element == null) {
      throw new BuiltValueNullFieldError('SourceInfo', 'element');
    }
    if (uri == null) {
      throw new BuiltValueNullFieldError('SourceInfo', 'uri');
    }
  }

  @override
  Iterable<String> get importUris => __importUris ??= super.importUris;

  @override
  Iterable<MethodInfo> get methods => __methods ??= super.methods;

  @override
  SourceInfo rebuild(void Function(SourceInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SourceInfoBuilder toBuilder() => new SourceInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SourceInfo &&
        classes == other.classes &&
        element == other.element &&
        uri == other.uri;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, classes.hashCode), element.hashCode), uri.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('SourceInfo')
          ..add('classes', classes)
          ..add('element', element)
          ..add('uri', uri))
        .toString();
  }
}

class SourceInfoBuilder implements Builder<SourceInfo, SourceInfoBuilder> {
  _$SourceInfo _$v;

  Iterable<ClassInfo> _classes;
  Iterable<ClassInfo> get classes => _$this._classes;
  set classes(Iterable<ClassInfo> classes) => _$this._classes = classes;

  LibraryElement _element;
  LibraryElement get element => _$this._element;
  set element(LibraryElement element) => _$this._element = element;

  Uri _uri;
  Uri get uri => _$this._uri;
  set uri(Uri uri) => _$this._uri = uri;

  SourceInfoBuilder();

  SourceInfoBuilder get _$this {
    if (_$v != null) {
      _classes = _$v.classes;
      _element = _$v.element;
      _uri = _$v.uri;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SourceInfo other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$SourceInfo;
  }

  @override
  void update(void Function(SourceInfoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$SourceInfo build() {
    final _$result =
        _$v ?? new _$SourceInfo._(classes: classes, element: element, uri: uri);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
