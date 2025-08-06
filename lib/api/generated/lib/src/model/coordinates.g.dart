// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coordinates.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Coordinates extends Coordinates {
  @override
  final String? lat;
  @override
  final String? lng;

  factory _$Coordinates([void Function(CoordinatesBuilder)? updates]) =>
      (CoordinatesBuilder()..update(updates))._build();

  _$Coordinates._({this.lat, this.lng}) : super._();
  @override
  Coordinates rebuild(void Function(CoordinatesBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CoordinatesBuilder toBuilder() => CoordinatesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Coordinates && lat == other.lat && lng == other.lng;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lat.hashCode);
    _$hash = $jc(_$hash, lng.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Coordinates')
          ..add('lat', lat)
          ..add('lng', lng))
        .toString();
  }
}

class CoordinatesBuilder implements Builder<Coordinates, CoordinatesBuilder> {
  _$Coordinates? _$v;

  String? _lat;
  String? get lat => _$this._lat;
  set lat(String? lat) => _$this._lat = lat;

  String? _lng;
  String? get lng => _$this._lng;
  set lng(String? lng) => _$this._lng = lng;

  CoordinatesBuilder() {
    Coordinates._defaults(this);
  }

  CoordinatesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lat = $v.lat;
      _lng = $v.lng;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Coordinates other) {
    _$v = other as _$Coordinates;
  }

  @override
  void update(void Function(CoordinatesBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Coordinates build() => _build();

  _$Coordinates _build() {
    final _$result = _$v ?? _$Coordinates._(lat: lat, lng: lng);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
