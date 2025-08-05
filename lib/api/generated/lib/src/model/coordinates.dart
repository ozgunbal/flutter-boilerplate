//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'coordinates.g.dart';

/// Coordinates
///
/// Properties:
/// * [lat] - Latitude coordinate
/// * [lng] - Longitude coordinate
@BuiltValue()
abstract class Coordinates implements Built<Coordinates, CoordinatesBuilder> {
  /// Latitude coordinate
  @BuiltValueField(wireName: r'lat')
  String? get lat;

  /// Longitude coordinate
  @BuiltValueField(wireName: r'lng')
  String? get lng;

  Coordinates._();

  factory Coordinates([void updates(CoordinatesBuilder b)]) = _$Coordinates;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CoordinatesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<Coordinates> get serializer => _$CoordinatesSerializer();
}

class _$CoordinatesSerializer implements PrimitiveSerializer<Coordinates> {
  @override
  final Iterable<Type> types = const [Coordinates, _$Coordinates];

  @override
  final String wireName = r'Coordinates';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    Coordinates object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.lat != null) {
      yield r'lat';
      yield serializers.serialize(
        object.lat,
        specifiedType: const FullType(String),
      );
    }
    if (object.lng != null) {
      yield r'lng';
      yield serializers.serialize(
        object.lng,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    Coordinates object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CoordinatesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lat':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lat = valueDes;
          break;
        case r'lng':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.lng = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  Coordinates deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CoordinatesBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

