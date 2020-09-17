// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ClassEntry extends ClassEntry {
  @override
  final String className;
  @override
  final String method;
  @override
  final String tag;
  @override
  final Iterable<FieldEntry> fields;

  factory _$ClassEntry([void Function(ClassEntryBuilder) updates]) =>
      (new ClassEntryBuilder()..update(updates)).build();

  _$ClassEntry._({this.className, this.method, this.tag, this.fields})
      : super._() {
    if (className == null) {
      throw new BuiltValueNullFieldError('ClassEntry', 'className');
    }
    if (method == null) {
      throw new BuiltValueNullFieldError('ClassEntry', 'method');
    }
    if (tag == null) {
      throw new BuiltValueNullFieldError('ClassEntry', 'tag');
    }
    if (fields == null) {
      throw new BuiltValueNullFieldError('ClassEntry', 'fields');
    }
  }

  @override
  ClassEntry rebuild(void Function(ClassEntryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClassEntryBuilder toBuilder() => new ClassEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClassEntry &&
        className == other.className &&
        method == other.method &&
        tag == other.tag &&
        fields == other.fields;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, className.hashCode), method.hashCode), tag.hashCode),
        fields.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ClassEntry')
          ..add('className', className)
          ..add('method', method)
          ..add('tag', tag)
          ..add('fields', fields))
        .toString();
  }
}

class ClassEntryBuilder implements Builder<ClassEntry, ClassEntryBuilder> {
  _$ClassEntry _$v;

  String _className;
  String get className => _$this._className;
  set className(String className) => _$this._className = className;

  String _method;
  String get method => _$this._method;
  set method(String method) => _$this._method = method;

  String _tag;
  String get tag => _$this._tag;
  set tag(String tag) => _$this._tag = tag;

  Iterable<FieldEntry> _fields;
  Iterable<FieldEntry> get fields => _$this._fields;
  set fields(Iterable<FieldEntry> fields) => _$this._fields = fields;

  ClassEntryBuilder();

  ClassEntryBuilder get _$this {
    if (_$v != null) {
      _className = _$v.className;
      _method = _$v.method;
      _tag = _$v.tag;
      _fields = _$v.fields;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClassEntry other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$ClassEntry;
  }

  @override
  void update(void Function(ClassEntryBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ClassEntry build() {
    final _$result = _$v ??
        new _$ClassEntry._(
            className: className, method: method, tag: tag, fields: fields);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
