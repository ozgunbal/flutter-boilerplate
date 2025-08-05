//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:api_client/src/date_serializer.dart';
import 'package:api_client/src/model/date.dart';

import 'package:api_client/src/model/address.dart';
import 'package:api_client/src/model/company.dart';
import 'package:api_client/src/model/coordinates.dart';
import 'package:api_client/src/model/create_user_request.dart';
import 'package:api_client/src/model/error.dart';
import 'package:api_client/src/model/post.dart';
import 'package:api_client/src/model/update_user_request.dart';
import 'package:api_client/src/model/user.dart';

part 'serializers.g.dart';

@SerializersFor([
  Address,
  Company,
  Coordinates,
  CreateUserRequest,
  Error,
  Post,
  UpdateUserRequest,
  User,
])
Serializers serializers = (_$serializers.toBuilder()
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(User)]),
        () => ListBuilder<User>(),
      )
      ..addBuilderFactory(
        const FullType(BuiltList, [FullType(Post)]),
        () => ListBuilder<Post>(),
      )
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer()))
    .build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
