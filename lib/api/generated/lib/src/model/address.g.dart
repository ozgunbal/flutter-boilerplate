// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Address extends Address {
  @override
  final String? street;
  @override
  final String? suite;
  @override
  final String? city;
  @override
  final String? zipcode;
  @override
  final Coordinates? geo;

  factory _$Address([void Function(AddressBuilder)? updates]) =>
      (AddressBuilder()..update(updates))._build();

  _$Address._({this.street, this.suite, this.city, this.zipcode, this.geo})
      : super._();
  @override
  Address rebuild(void Function(AddressBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AddressBuilder toBuilder() => AddressBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Address &&
        street == other.street &&
        suite == other.suite &&
        city == other.city &&
        zipcode == other.zipcode &&
        geo == other.geo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, street.hashCode);
    _$hash = $jc(_$hash, suite.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, zipcode.hashCode);
    _$hash = $jc(_$hash, geo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Address')
          ..add('street', street)
          ..add('suite', suite)
          ..add('city', city)
          ..add('zipcode', zipcode)
          ..add('geo', geo))
        .toString();
  }
}

class AddressBuilder implements Builder<Address, AddressBuilder> {
  _$Address? _$v;

  String? _street;
  String? get street => _$this._street;
  set street(String? street) => _$this._street = street;

  String? _suite;
  String? get suite => _$this._suite;
  set suite(String? suite) => _$this._suite = suite;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _zipcode;
  String? get zipcode => _$this._zipcode;
  set zipcode(String? zipcode) => _$this._zipcode = zipcode;

  CoordinatesBuilder? _geo;
  CoordinatesBuilder get geo => _$this._geo ??= CoordinatesBuilder();
  set geo(CoordinatesBuilder? geo) => _$this._geo = geo;

  AddressBuilder() {
    Address._defaults(this);
  }

  AddressBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _street = $v.street;
      _suite = $v.suite;
      _city = $v.city;
      _zipcode = $v.zipcode;
      _geo = $v.geo?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Address other) {
    _$v = other as _$Address;
  }

  @override
  void update(void Function(AddressBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Address build() => _build();

  _$Address _build() {
    _$Address _$result;
    try {
      _$result = _$v ??
          _$Address._(
            street: street,
            suite: suite,
            city: city,
            zipcode: zipcode,
            geo: _geo?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'geo';
        _geo?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'Address', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
