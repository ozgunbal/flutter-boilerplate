// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Company extends Company {
  @override
  final String? name;
  @override
  final String? catchPhrase;
  @override
  final String? bs;

  factory _$Company([void Function(CompanyBuilder)? updates]) =>
      (CompanyBuilder()..update(updates))._build();

  _$Company._({this.name, this.catchPhrase, this.bs}) : super._();
  @override
  Company rebuild(void Function(CompanyBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CompanyBuilder toBuilder() => CompanyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Company &&
        name == other.name &&
        catchPhrase == other.catchPhrase &&
        bs == other.bs;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, catchPhrase.hashCode);
    _$hash = $jc(_$hash, bs.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Company')
          ..add('name', name)
          ..add('catchPhrase', catchPhrase)
          ..add('bs', bs))
        .toString();
  }
}

class CompanyBuilder implements Builder<Company, CompanyBuilder> {
  _$Company? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _catchPhrase;
  String? get catchPhrase => _$this._catchPhrase;
  set catchPhrase(String? catchPhrase) => _$this._catchPhrase = catchPhrase;

  String? _bs;
  String? get bs => _$this._bs;
  set bs(String? bs) => _$this._bs = bs;

  CompanyBuilder() {
    Company._defaults(this);
  }

  CompanyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _catchPhrase = $v.catchPhrase;
      _bs = $v.bs;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Company other) {
    _$v = other as _$Company;
  }

  @override
  void update(void Function(CompanyBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Company build() => _build();

  _$Company _build() {
    final _$result =
        _$v ?? _$Company._(name: name, catchPhrase: catchPhrase, bs: bs);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
