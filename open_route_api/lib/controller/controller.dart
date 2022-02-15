part of open_route_api;
Logger log = Logger();
class OpenRoute {
////////////////////////////////////////////////////////////////////////////
// /v2/directions/{profile}/geojson (POST Method)
////////////////////////////////////////////////////////////////////////////
  static Future<List<LatLng>> directionGeoJson({
    required String profile,
    required String apiKey,
    required List<LatLng> coordinates,
  })async {
    List<LatLng> polyList = <LatLng>[];
    PostDirection postDirection = PostDirection(
      List<List<double>>.generate(
        coordinates.length, 
        (i) => [coordinates[i].longitude,coordinates[i].latitude]
      )
    );
    await ApiService(Dio())
    .postDirectionGeo(apiKey, profile, postDirection)
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
////////////////////////////////////////////////////////////////////////////
// /v2/directions/{profile} (POST Method)
////////////////////////////////////////////////////////////////////////////
  static Future<List<Routes>> directionToRoutes({
    required String profile,
    required String apiKey,
    required List<LatLng> coordinates,
  })async {
    RouteDirection routeDirection = RouteDirection([]);
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
    return routeDirection.routes;
  }
////////////////////////////////////////////////////////////////////////////
// /v2/directions/{profile} (GET Method)
////////////////////////////////////////////////////////////////////////////
  static Future<List<LatLng>> getDirection({
    required String profile,
    required String apiKey,
    required LatLng start,
    required LatLng end,
  })async{
    List<LatLng> polyList = <LatLng>[];
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
////////////////////////////////////////////////////////////////////////////
// find nearest route method
////////////////////////////////////////////////////////////////////////////
  static Future<List<PointInfo>> sortRoute({
    required String apiKey,
    required String profile,
    required LatLng home,
    required List<LatLng> destinations,
  })async{
    List<PointInfo> allPoint = List<PointInfo>.generate(
      destinations.length, 
      (i) => PointInfo(
        coordinate: destinations[i],
        apiSuccess: false,
        distance: 0.0,
        duration: 0.0,
      )
    );
    log.i('start from ${DateTime.now().hour}:${DateTime.now().second}');
    for(int y=0;y<allPoint.length;y++){      
      await directionToRoutes(
        apiKey: apiKey,
        profile: profile,
        coordinates: [home, allPoint[y].coordinate]
      ).then((value){
        allPoint[y].apiSuccess=true;
        allPoint[y].distance = value[0].summary.distance;
        allPoint[y].duration = value[0].summary.duration;
      });
    }
    // double check for network connection
    for(int y=0;y<allPoint.length;y++){
      if(allPoint[y].apiSuccess==false){
        await directionToRoutes(
          apiKey: apiKey,
          profile: profile,
          coordinates: [home, allPoint[y].coordinate]
        ).then((value){
          allPoint[y].apiSuccess=true;
          allPoint[y].distance = value[0].summary.distance;
          allPoint[y].duration = value[0].summary.duration;
        });
      }
    }
    List tmp = allPoint.where((e) => e.apiSuccess==false).toList();
    if(tmp.isNotEmpty){
      throw Exception('Unknown Error');
    }
    allPoint.sort((a, b) => a.distance.compareTo(b.distance));
    log.i('end at ${DateTime.now().hour}:${DateTime.now().second}');
    return allPoint;
  }
}

class PointInfo {
  LatLng coordinate;
  bool apiSuccess;
  double distance;
  double duration;
  PointInfo({required this.coordinate,required this.apiSuccess, required this.distance, required this.duration});
}