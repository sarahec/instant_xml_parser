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

part of 'constructor_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ConstructorInfo extends ConstructorInfo {
  @override
  final ConstructorElement element;

  factory _$ConstructorInfo([void Function(ConstructorInfoBuilder) updates]) =>
      (new ConstructorInfoBuilder()..update(updates)).build();

  _$ConstructorInfo._({this.element}) : super._() {
    if (element == null) {
      throw new BuiltValueNullFieldError('ConstructorInfo', 'element');
    }
  }

  @override
  ConstructorInfo rebuild(void Function(ConstructorInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ConstructorInfoBuilder toBuilder() =>
      new ConstructorInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ConstructorInfo && element == other.element;
  }

  @override
  int get hashCode {
    return $jf($jc(0, element.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ConstructorInfo')
          ..add('element', element))
        .toString();
  }
}

class ConstructorInfoBuilder
    implements Builder<ConstructorInfo, ConstructorInfoBuilder> {
  _$ConstructorInfo _$v;

  ConstructorElement _element;
  ConstructorElement get element => _$this._element;
  set element(ConstructorElement element) => _$this._element = element;

  ConstructorInfoBuilder();

  ConstructorInfoBuilder get _$this {
    if (_$v != null) {
      _element = _$v.element;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ConstructorInfo other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ConstructorInfo;
  }

  @override
  void update(void Function(ConstructorInfoBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ConstructorInfo build() {
    final _$result = _$v ?? new _$ConstructorInfo._(element: element);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
