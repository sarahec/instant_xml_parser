// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_info.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FieldInfo extends FieldInfo {
  @override
  final String attribute;
  @override
  final bool isList;
  @override
  final bool isText;
  @override
  final String name;
  @override
  final String trueIfEquals;
  @override
  final String trueIfMatches;
  @override
  final DartType type;
  String __typeName;

  factory _$FieldInfo([void Function(FieldInfoBuilder) updates]) =>
      (new FieldInfoBuilder()..update(updates)).build();

  _$FieldInfo._(
      {this.attribute,
      this.isList,
      this.isText,
      this.name,
      this.trueIfEquals,
      this.trueIfMatches,
      this.type})
      : super._() {
    if (isList == null) {
      throw new BuiltValueNullFieldError('FieldInfo', 'isList');
    }
    if (isText == null) {
      throw new BuiltValueNullFieldError('FieldInfo', 'isText');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('FieldInfo', 'name');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('FieldInfo', 'type');
    }
  }

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
    return other is FieldInfo &&
        attribute == other.attribute &&
        isList == other.isList &&
        isText == other.isText &&
        name == other.name &&
        trueIfEquals == other.trueIfEquals &&
        trueIfMatches == other.trueIfMatches &&
        type == other.type;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, attribute.hashCode), isList.hashCode),
                        isText.hashCode),
                    name.hashCode),
                trueIfEquals.hashCode),
            trueIfMatches.hashCode),
        type.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FieldInfo')
          ..add('attribute', attribute)
          ..add('isList', isList)
          ..add('isText', isText)
          ..add('name', name)
          ..add('trueIfEquals', trueIfEquals)
          ..add('trueIfMatches', trueIfMatches)
          ..add('type', type))
        .toString();
  }
}

class FieldInfoBuilder implements Builder<FieldInfo, FieldInfoBuilder> {
  _$FieldInfo _$v;

  String _attribute;
  String get attribute => _$this._attribute;
  set attribute(String attribute) => _$this._attribute = attribute;

  bool _isList;
  bool get isList => _$this._isList;
  set isList(bool isList) => _$this._isList = isList;

  bool _isText;
  bool get isText => _$this._isText;
  set isText(bool isText) => _$this._isText = isText;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _trueIfEquals;
  String get trueIfEquals => _$this._trueIfEquals;
  set trueIfEquals(String trueIfEquals) => _$this._trueIfEquals = trueIfEquals;

  String _trueIfMatches;
  String get trueIfMatches => _$this._trueIfMatches;
  set trueIfMatches(String trueIfMatches) =>
      _$this._trueIfMatches = trueIfMatches;

  DartType _type;
  DartType get type => _$this._type;
  set type(DartType type) => _$this._type = type;

  FieldInfoBuilder();

  FieldInfoBuilder get _$this {
    if (_$v != null) {
      _attribute = _$v.attribute;
      _isList = _$v.isList;
      _isText = _$v.isText;
      _name = _$v.name;
      _trueIfEquals = _$v.trueIfEquals;
      _trueIfMatches = _$v.trueIfMatches;
      _type = _$v.type;
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
    final _$result = _$v ??
        new _$FieldInfo._(
            attribute: attribute,
            isList: isList,
            isText: isText,
            name: name,
            trueIfEquals: trueIfEquals,
            trueIfMatches: trueIfMatches,
            type: type);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
