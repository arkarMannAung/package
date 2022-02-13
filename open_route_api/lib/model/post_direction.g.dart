// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_direction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDirection _$PostDirectionFromJson(Map<String, dynamic> json) =>
    PostDirection(
      (json['coordinates'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toDouble()).toList())
          .toList(),
    );

Map<String, dynamic> _$PostDirectionToJson(PostDirection instance) =>
    <String, dynamic>{
      'coordinates': instance.coordinates,
    };

RouteDirection _$RouteDirectionFromJson(Map<String, dynamic> json) =>
    RouteDirection(
      (json['routes'] as List<dynamic>)
          .map((e) => Routes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RouteDirectionToJson(RouteDirection instance) =>
    <String, dynamic>{
      'routes': instance.routes,
    };

Routes _$RoutesFromJson(Map<String, dynamic> json) => Routes(
      Summary.fromJson(json['summary'] as Map<String, dynamic>),
      (json['segments'] as List<dynamic>)
          .map((e) => Segment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RoutesToJson(Routes instance) => <String, dynamic>{
      'summary': instance.summary,
      'segments': instance.segments,
    };

Summary _$SummaryFromJson(Map<String, dynamic> json) => Summary(
      (json['distance'] as num).toDouble(),
      (json['duration'] as num).toDouble(),
    );

Map<String, dynamic> _$SummaryToJson(Summary instance) => <String, dynamic>{
      'distance': instance.distance,
      'duration': instance.duration,
    };

Segment _$SegmentFromJson(Map<String, dynamic> json) => Segment(
      (json['distance'] as num).toDouble(),
      (json['duration'] as num).toDouble(),
      (json['steps'] as List<dynamic>)
          .map((e) => Step.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SegmentToJson(Segment instance) => <String, dynamic>{
      'distance': instance.distance,
      'duration': instance.duration,
      'steps': instance.steps,
    };

Step _$StepFromJson(Map<String, dynamic> json) => Step(
      (json['distance'] as num).toDouble(),
      (json['duration'] as num).toDouble(),
      json['instruction'] as String,
      json['name'] as String,
      json['type'] as int,
      json['way_points'] as List<dynamic>,
    );

Map<String, dynamic> _$StepToJson(Step instance) => <String, dynamic>{
      'distance': instance.distance,
      'duration': instance.duration,
      'type': instance.type,
      'instruction': instance.instruction,
      'name': instance.name,
      'way_points': instance.wayPoints,
    };
