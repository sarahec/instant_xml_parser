// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<LibraryInfo> _$libraryInfoSerializer = new _$LibraryInfoSerializer();

class _$LibraryInfoSerializer implements StructuredSerializer<LibraryInfo> {
  @override
  final Iterable<Type> types = const [LibraryInfo, _$LibraryInfo];
  @override
  final String wireName = 'LibraryInfo';

  @override
  Iterable<Object> serialize(Serializers serializers, LibraryInfo object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'uri',
      serializers.serialize(object.uri, specifiedType: const FullType(Uri)),
      'classes',
      serializers.serialize(object.classes,
          specifiedType:
              const FullType(Iterable, const [const FullType(ClassInfo)])),
      'element',
      serializers.serialize(object.element,
          specifiedType: const FullType(LibraryElement)),
    ];

    return result;
  }

  @override
  LibraryInfo deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new LibraryInfoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'uri':
          result.uri = serializers.deserialize(value,
              specifiedType: const FullType(Uri)) as Uri;
          break;
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
      }
    }

    return result.build();
  }
}

class _$LibraryInfo extends LibraryInfo {
  @override
  final Uri uri;
  @override
  final Iterable<ClassInfo> classes;
  @override
  final LibraryElement element;
  Iterable<String> __importUris;

  factory _$LibraryInfo([void Function(LibraryInfoBuilder) updates]) =>
      (new LibraryInfoBuilder()..update(updates)).build();

  _$LibraryInfo._({this.uri, this.classes, this.element}) : super._() {
    if (uri == null) {
      throw new BuiltValueNullFieldError('LibraryInfo', 'uri');
    }
    if (classes == null) {
      throw new BuiltValueNullFieldError('LibraryInfo', 'classes');
    }
    if (element == null) {
      throw new BuiltValueNullFieldError('LibraryInfo', 'element');
    }
  }

  @override
  Iterable<String> get importUris => __importUris ??= super.importUris;

  @override
  LibraryInfo rebuild(void Function(LibraryInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LibraryInfoBuilder toBuilder() => new LibraryInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LibraryInfo &&
        uri == other.uri &&
        classes == other.classes &&
        element == other.element;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, uri.hashCode), classes.hashCode), element.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LibraryInfo')
          ..add('uri', uri)
          ..add('classes', classes)
          ..add('element', element))
        .toString();
  }
}

class LibraryInfoBuilder implements Builder<LibraryInfo, LibraryInfoBuilder> {
  _$LibraryInfo _$v;

  Uri _uri;
  Uri get uri => _$this._uri;
  set uri(Uri uri) => _$this._uri = uri;

  Iterable<ClassInfo> _classes;
  Iterable<ClassInfo> get classes => _$this._classes;
  set classes(Iterable<ClassInfo> classes) => _$this._classes = classes;

  LibraryElement _element;
  LibraryElement get element => _$this._element;
  set element(LibraryElement element) => _$this._element = element;

  LibraryInfoBuilder();

  LibraryInfoBuilder get _$this {
    if (_$v != null) {
      _uri = _$v.uri;
      _classes = _$v.classes;
      _element = _$v.element;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LibraryInfo other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$LibraryInfo;
  }

  @override
  void update(void Function(LibraryInfoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$LibraryInfo build() {
    final _$result = _$v ??
        new _$LibraryInfo._(uri: uri, classes: classes, element: element);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
