import 'package:dio/dio.dart';
import 'package:open_route_api/model/get_direction.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://api.openrouteservice.org/v2/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('directions/{profile}')
  // Future<GetDirectionResponse> getDirecction(
  Future<String> getDirection(
    @Path('profile') String profile,
    @Query('api_key') String apiKey,
    @Query('start') String start,
    @Query('end') String end,
  );
}