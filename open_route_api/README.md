
# Flutter Network Package for
# "Open Route Service"




## Installing
##### open_route_api:
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;git:
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;url: https://github.com/arkarMannAung/package.git
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;path: open_route_api




## Example
### /v2/directions/{profile} (GET Method)
##### String profile = 'driving-car';
##### String apiKey = 'b3ce3597851110001cf62482bcc530e03734e74af9f467ae3294ab9';
##### LatLng start = const LatLng(16.838094,96.243881);
##### LatLng end = const LatLng(16.778769, 96.170669);
##### OpenRoute.getDirection(
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;profile: profile,
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;apiKey: apiKey,
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;start: start,
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;end: end
##### ).then((value){
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;log.e(value.length);
##### }).onError((error, stackTrace){
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;log.e((error as DioError).response);
##### });

### /v2/directions/{profile} (POST Method)
##### String profile = 'driving-car';
##### String apiKey = 'b3ce3597851110001cf62482bcc530e03734e74af9f467ae3294ab9';
##### List<LatLng> coordinates = const[
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LatLng(16.814949, 96.133929),
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LatLng(16.793760, 96.140018),
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LatLng(16.799293, 96.157569),
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LatLng(16.789329, 96.175711),
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;];
##### OpenRoute            .directionToRoutes(
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;profile: profile, 
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;apiKey: apiKey, 
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;coordinates: coordinates
##### ).then((value){
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;log.d(value.length);
##### }).onError((error, stackTrace){
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;log.e((error as DioError).response);
##### });

### /v2/directions/{profile}/geojson (POST Method)
##### String profile = 'driving-car';
##### String apiKey = 'b3ce3597851110001cf62482bcc530e03734e74af9f467ae3294ab9';
##### List<LatLng> coordinates = const[
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LatLng(16.814949, 96.133929),
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LatLng(16.793760, 96.140018),
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LatLng(16.799293, 96.157569),
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LatLng(16.789329, 96.175711),
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;];          
##### OpenRoute.directionGeoJson(
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;profile: profile, 
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;apiKey: apiKey,
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;coordinates: coordinates
##### ).then((value){
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;log.e(value.length);
##### }).onError((error, stackTrace){
##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;log.e((error as DioError).response);
##### });


## Feedback

If you have any feedback, please reach out to us at mr.arkarmannaung@gmail.com

