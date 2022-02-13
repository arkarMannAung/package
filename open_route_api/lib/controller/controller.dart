part of open_route_api;
Logger log = Logger();
class OpenRoute {
  static List<LatLng> polyList = <LatLng>[];
  static RouteDirection routeDirection = RouteDirection([]);

  static Future<RouteDirection> postDirection({
    required String profile,
    required String apiKey,
    required List<LatLng> coordinates,
  })async {
    
    PostDirection postDirection = PostDirection(
      List<List<double>>.generate(
        coordinates.length, 
        (i) => [coordinates[i].longitude,coordinates[i].latitude]
      )
    );
    await ApiService(Dio())
    .postDirection(apiKey, profile, postDirection)
    .then((value){
      Map<String,dynamic> json = jsonDecode(value);
      routeDirection = RouteDirection.fromJson(json);
    })
    .onError((error, stackTrace){
      throw DioError(
        requestOptions: (error as DioError).requestOptions,
        error: error.error,
        response: error.response,
      );
    });
    return routeDirection;
  }


  static Future<List<LatLng>> getDirection({
    required String profile,
    required String apiKey,
    required LatLng start,
    required LatLng end,
  })async{
    await ApiService(Dio())
    .getDirection(
      profile, 
      apiKey, 
      '${start.longitude},${start.latitude}',
      '${end.longitude},${end.latitude}'
    )
    .then((value){
      Map<String,dynamic> json = jsonDecode(value);
      GetDirectionResponse getDirectionResponse = GetDirectionResponse.fromJson(json);
      polyList = List<LatLng>.generate(
        getDirectionResponse.features[0].geometry.coordinates.length,
        (index) => LatLng(getDirectionResponse.features[0].geometry.coordinates[index][1],getDirectionResponse.features[0].geometry.coordinates[index][0])
      );      
    })
    .onError((error, stackTrace){
      throw DioError(
        requestOptions: (error as DioError).requestOptions,
        error: error.error,
        response: error.response,
      );
    });
    return polyList;
  }
}