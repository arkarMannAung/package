// import 'package:json_annotation/json_annotation.dart';
part 'get_direction.g.dart';

// @JsonSerializable()
class GetDirectionResponse {
  List<Feature> features;
  GetDirectionResponse(this.features);
  factory GetDirectionResponse.fromJson( Map<String,dynamic> json) => _$GetDirectionResponseFromJson(json);
}

// @JsonSerializable()
class Feature {
  Geometry geometry;
  Feature(this.geometry);
  factory Feature.fromJson( Map<String,dynamic> json ) => _$FeatureFromJson(json);
}

// @JsonSerializable()
class Geometry {
  List<List<double>> coordinates;
  Geometry(this.coordinates);
  factory Geometry.fromJson( Map<String,dynamic> json) => _$GeometryFromJson(json);
}
