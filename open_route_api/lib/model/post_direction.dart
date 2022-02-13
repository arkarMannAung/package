// import 'package:json_annotation/json_annotation.dart';
part 'post_direction.g.dart';

// @JsonSerializable()
class PostDirection {
  List<List<double>> coordinates;
  PostDirection(this.coordinates);
  Map<String,dynamic> toJson() => _$PostDirectionToJson(this);
}

// @JsonSerializable()
class RouteDirection {
  List<Routes> routes;
  RouteDirection(this.routes);
  factory RouteDirection.fromJson( Map<String,dynamic> json) => _$RouteDirectionFromJson(json);
}

// @JsonSerializable()
class Routes {
  Summary summary;
  List<Segment> segments;
  Routes(this.summary,this.segments);
  factory Routes.fromJson( Map<String,dynamic> json) => _$RoutesFromJson(json);
}

// @JsonSerializable()
class Summary {
  double distance;
  double duration;
  Summary(this.distance,this.duration);
  factory Summary.fromJson( Map<String,dynamic> json) => _$SummaryFromJson(json);
}

// @JsonSerializable()
class Segment {
  double distance;
  double duration;
  List<Step> steps;
  Segment(this.distance,this.duration,this.steps);
  factory Segment.fromJson( Map<String,dynamic> json) => _$SegmentFromJson(json);
}

// @JsonSerializable()
class Step {
  double distance;
  double duration;
  int type;
  String instruction;
  String name;
  // @JsonKey(name: 'way_points')
  List wayPoints;
  Step(this.distance,this.duration,this.instruction,this.name,this.type,this.wayPoints);
  factory Step.fromJson( Map<String,dynamic> json) => _$StepFromJson(json);
}
