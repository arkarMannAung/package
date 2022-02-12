// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_direction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetDirectionResponse _$GetDirectionResponseFromJson(
        Map<String, dynamic> json) =>
    GetDirectionResponse(
      (json['features'] as List<dynamic>)
          .map((e) => Feature.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetDirectionResponseToJson(
        GetDirectionResponse instance) =>
    <String, dynamic>{
      'features': instance.features,
    };

Feature _$FeatureFromJson(Map<String, dynamic> json) => Feature(
      Geometry.fromJson(json['geometry'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FeatureToJson(Feature instance) => <String, dynamic>{
      'geometry': instance.geometry,
    };

Geometry _$GeometryFromJson(Map<String, dynamic> json) => Geometry(
      (json['coordinates'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
          .toList(),
    );

Map<String, dynamic> _$GeometryToJson(Geometry instance) => <String, dynamic>{
      'coordinates': instance.coordinates,
    };
