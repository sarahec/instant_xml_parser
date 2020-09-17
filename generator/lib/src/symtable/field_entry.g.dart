// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_entry.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FieldEntry extends FieldEntry {
  @override
  final String tag;
  @override
  final String attribute;
  @override
  final String name;
  @override
  final String methodName;
  @override
  final DartType type;
  @override
  final String trueIfEquals;
  @override
  final RegExp trueIfMatches;

  factory _$FieldEntry([void Function(FieldEntryBuilder) updates]) =>
      (new FieldEntryBuilder()..update(updates)).build();

  _$FieldEntry._(
      {this.tag,
      this.attribute,
      this.name,
      this.methodName,
      this.type,
      this.trueIfEquals,
      this.trueIfMatches})
      : super._() {
    if (attribute == null) {
      throw new BuiltValueNullFieldError('FieldEntry', 'attribute');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('FieldEntry', 'name');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('FieldEntry', 'type');
    }
  }

  @override
  FieldEntry rebuild(void Function(FieldEntryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FieldEntryBuilder toBuilder() => new FieldEntryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FieldEntry &&
        tag == other.tag &&
        attribute == other.attribute &&
        name == other.name &&
        methodName == other.methodName &&
        type == other.type &&
        trueIfEquals == other.trueIfEquals &&
        trueIfMatches == other.trueIfMatches;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, tag.hashCode), attribute.hashCode),
                        name.hashCode),
                    methodName.hashCode),
                type.hashCode),
            trueIfEquals.hashCode),
        trueIfMatches.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FieldEntry')
          ..add('tag', tag)
          ..add('attribute', attribute)
          ..add('name', name)
          ..add('methodName', methodName)
          ..add('type', type)
          ..add('trueIfEquals', trueIfEquals)
          ..add('trueIfMatches', trueIfMatches))
        .toString();
  }
}

class FieldEntryBuilder implements Builder<FieldEntry, FieldEntryBuilder> {
  _$FieldEntry _$v;

  String _tag;
  String get tag => _$this._tag;
  set tag(String tag) => _$this._tag = tag;

  String _attribute;
  String get attribute => _$this._attribute;
  set attribute(String attribute) => _$this._attribute = attribute;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _methodName;
  String get methodName => _$this._methodName;
  set methodName(String methodName) => _$this._methodName = methodName;

  DartType _type;
  DartType get type => _$this._type;
  set type(DartType type) => _$this._type = type;

  String _trueIfEquals;
  String get trueIfEquals => _$this._trueIfEquals;
  set trueIfEquals(String trueIfEquals) => _$this._trueIfEquals = trueIfEquals;

  RegExp _trueIfMatches;
  RegExp get trueIfMatches => _$this._trueIfMatches;
  set trueIfMatches(RegExp trueIfMatches) =>
      _$this._trueIfMatches = trueIfMatches;

  FieldEntryBuilder();

  FieldEntryBuilder get _$this {
    if (_$v != null) {
      _tag = _$v.tag;
      _attribute = _$v.attribute;
      _name = _$v.name;
      _methodName = _$v.methodName;
      _type = _$v.type;
      _trueIfEquals = _$v.trueIfEquals;
      _trueIfMatches = _$v.trueIfMatches;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FieldEntry other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FieldEntry;
  }

  @override
  void update(void Function(FieldEntryBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FieldEntry build() {
    final _$result = _$v ??
        new _$FieldEntry._(
            tag: tag,
            attribute: attribute,
            name: name,
            methodName: methodName,
            type: type,
            trueIfEquals: trueIfEquals,
            trueIfMatches: trueIfMatches);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
