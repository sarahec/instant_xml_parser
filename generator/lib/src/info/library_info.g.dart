// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LibraryInfo extends LibraryInfo {
  @override
  final LibraryElement element;
  @override
  final Symtable symtable;
  Iterable<String> __importUris;

  factory _$LibraryInfo([void Function(LibraryInfoBuilder) updates]) =>
      (new LibraryInfoBuilder()..update(updates)).build();

  _$LibraryInfo._({this.element, this.symtable}) : super._() {
    if (element == null) {
      throw new BuiltValueNullFieldError('LibraryInfo', 'element');
    }
    if (symtable == null) {
      throw new BuiltValueNullFieldError('LibraryInfo', 'symtable');
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
        element == other.element &&
        symtable == other.symtable;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, element.hashCode), symtable.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LibraryInfo')
          ..add('element', element)
          ..add('symtable', symtable))
        .toString();
  }
}

class LibraryInfoBuilder implements Builder<LibraryInfo, LibraryInfoBuilder> {
  _$LibraryInfo _$v;

  LibraryElement _element;
  LibraryElement get element => _$this._element;
  set element(LibraryElement element) => _$this._element = element;

  Symtable _symtable;
  Symtable get symtable => _$this._symtable;
  set symtable(Symtable symtable) => _$this._symtable = symtable;

  LibraryInfoBuilder();

  LibraryInfoBuilder get _$this {
    if (_$v != null) {
      _element = _$v.element;
      _symtable = _$v.symtable;
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
    final _$result =
        _$v ?? new _$LibraryInfo._(element: element, symtable: symtable);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
