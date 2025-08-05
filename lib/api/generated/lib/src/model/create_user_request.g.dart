// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CreateUserRequest extends CreateUserRequest {
  @override
  final String name;
  @override
  final String email;
  @override
  final String? username;
  @override
  final String? phone;
  @override
  final String? website;

  factory _$CreateUserRequest(
          [void Function(CreateUserRequestBuilder)? updates]) =>
      (CreateUserRequestBuilder()..update(updates))._build();

  _$CreateUserRequest._(
      {required this.name,
      required this.email,
      this.username,
      this.phone,
      this.website})
      : super._();
  @override
  CreateUserRequest rebuild(void Function(CreateUserRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CreateUserRequestBuilder toBuilder() =>
      CreateUserRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CreateUserRequest &&
        name == other.name &&
        email == other.email &&
        username == other.username &&
        phone == other.phone &&
        website == other.website;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, website.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CreateUserRequest')
          ..add('name', name)
          ..add('email', email)
          ..add('username', username)
          ..add('phone', phone)
          ..add('website', website))
        .toString();
  }
}

class CreateUserRequestBuilder
    implements Builder<CreateUserRequest, CreateUserRequestBuilder> {
  _$CreateUserRequest? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _website;
  String? get website => _$this._website;
  set website(String? website) => _$this._website = website;

  CreateUserRequestBuilder() {
    CreateUserRequest._defaults(this);
  }

  CreateUserRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _email = $v.email;
      _username = $v.username;
      _phone = $v.phone;
      _website = $v.website;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CreateUserRequest other) {
    _$v = other as _$CreateUserRequest;
  }

  @override
  void update(void Function(CreateUserRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CreateUserRequest build() => _build();

  _$CreateUserRequest _build() {
    final _$result = _$v ??
        _$CreateUserRequest._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'CreateUserRequest', 'name'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'CreateUserRequest', 'email'),
          username: username,
          phone: phone,
          website: website,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
