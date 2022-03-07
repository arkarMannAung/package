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
  static Future<List<LatLng>> sortRoute({
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
    List<LatLng> response = [];
    response.add(home);
    response.addAll(
      List<LatLng>.generate(
        allPoint.length, 
        (i) => allPoint[i].coordinate
      )
    );
    return response;
  }

////////////////////////////////////////////////////////////////////////////
// find nearest route method
////////////////////////////////////////////////////////////////////////////
  static Future<List<LatLng>> groupRoute({
    required String apiKey,
    required String profile,
    required LatLng myLocation,
    required List<GroupRoute> groupRoutes,
  })async{
    List<GroupRouteInfo> groupRouteInfo = List<GroupRouteInfo>.generate(
      groupRoutes.length, 
      (x) => GroupRouteInfo(
        primary: PointInfo(
          coordinate: LatLng(groupRoutes[x].primary.latitude,groupRoutes[x].primary.longitude),
          apiSuccess: false,
          distance: 0.0,
          duration: 0.0
        ),
        secondary: List<PointInfo>.generate(
          groupRoutes[x].secondary.length,
          (y) => PointInfo(
            coordinate: LatLng(groupRoutes[x].secondary[y].latitude,groupRoutes[x].secondary[y].longitude),
            apiSuccess: false,
            distance: 0.0, 
            duration: 0.0
          ),
        )
      )
    );

    // get information
    for(int x=0;x<groupRouteInfo.length;x++){      
      await directionToRoutes(
        apiKey: apiKey,
        profile: profile,
        coordinates: [myLocation, groupRouteInfo[x].primary.coordinate]
      ).then((value){
        groupRouteInfo[x].primary.apiSuccess=true;
        groupRouteInfo[x].primary.distance = value[0].summary.distance;
        groupRouteInfo[x].primary.duration = value[0].summary.duration;
      });
      // nested loop for secondary
      for(int y=0;y<groupRouteInfo[x].secondary.length;y++){
        await directionToRoutes(
          apiKey: apiKey,
          profile: profile,
          coordinates: [myLocation, groupRouteInfo[x].secondary[y].coordinate]
        ).then((value){
          groupRouteInfo[x].secondary[y].apiSuccess=true;
          groupRouteInfo[x].secondary[y].distance = value[0].summary.distance;
          groupRouteInfo[x].secondary[y].duration = value[0].summary.duration;
        });
      }
      // nested loop for secondary
    }

    // double check
    for(int x=0;x<groupRouteInfo.length;x++){
      if(groupRouteInfo[x].primary.apiSuccess==false){
        await directionToRoutes(
          apiKey: apiKey,
          profile: profile,
          coordinates: [myLocation, groupRouteInfo[x].primary.coordinate]
        ).then((value){
          groupRouteInfo[x].primary.apiSuccess=true;
          groupRouteInfo[x].primary.distance = value[0].summary.distance;
          groupRouteInfo[x].primary.duration = value[0].summary.duration;
        });
      }
      // nested loop for secondary
      for(int y=0;y<groupRouteInfo[x].secondary.length;y++){
        if(groupRouteInfo[x].secondary[y].apiSuccess==false){
          await directionToRoutes(
            apiKey: apiKey,
            profile: profile,
            coordinates: [myLocation, groupRouteInfo[x].secondary[y].coordinate]
          ).then((value){
            groupRouteInfo[x].secondary[y].apiSuccess=true;
            groupRouteInfo[x].secondary[y].distance = value[0].summary.distance;
            groupRouteInfo[x].secondary[y].duration = value[0].summary.duration;
          });
        }
      }
      // nested loop for secondary
    }
    // double check

    List tmp = groupRouteInfo.where((e) => e.primary.apiSuccess==false).toList();
    if(tmp.isNotEmpty){
      throw Exception('Unknown Error');
    }
    // check
    groupRouteInfo.sort((a, b) => a.primary.distance.compareTo(b.primary.distance));
    log.i('end at ${DateTime.now().hour}:${DateTime.now().second}');
    
    // processing for logical sorting
    List<LatLng> response = [];
    response.add(myLocation);
    // add primary first
      response.add(groupRouteInfo[0].primary.coordinate);
    for(int a=0;a<groupRouteInfo.length;a++){
      List<PointInfo> minorPointInfo = groupRouteInfo[a].secondary;
      if(a!=groupRouteInfo.length-1){
        minorPointInfo.add(groupRouteInfo[a+1].primary);
      }
      // sorting
      minorPointInfo.sort((a, b) => a.distance.compareTo(b.distance));
      List<LatLng> temp = List<LatLng>.generate(
        minorPointInfo.length, (index) => minorPointInfo[index].coordinate
      );
      response.addAll(temp);
    }
    // processing for logical sorting
    return response;
  }

}

class PointInfo {
  LatLng coordinate;
  bool apiSuccess;
  double distance;
  double duration;
  PointInfo({required this.coordinate,required this.apiSuccess, required this.distance, required this.duration});
}

class GroupRoute {
  LatLng primary;
  List<LatLng> secondary;
  GroupRoute({required this.primary,required this.secondary});
}

class GroupRouteInfo{
  PointInfo primary;
  List<PointInfo> secondary;
  GroupRouteInfo({required this.primary,required this.secondary});
}