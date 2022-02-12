part of open_route_api;
Logger log = Logger();
class OpenRoute {
  static List<LatLng> polyList = <LatLng>[];

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
      log.d(getDirectionResponse.features[0].geometry.coordinates[0]);
      polyList = List<LatLng>.generate(
        getDirectionResponse.features[0].geometry.coordinates.length,
        (index) => LatLng(getDirectionResponse.features[0].geometry.coordinates[index][1],getDirectionResponse.features[0].geometry.coordinates[index][0])
      );      
    })
    .onError((error, stackTrace){
      log.e(error);
    });
    return polyList;
  }

}