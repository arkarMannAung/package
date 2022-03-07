import 'dart:math';
import 'package:flutter/material.dart';
import 'package:open_route_api/open_route_api.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
// ignore_for_file: invalid_use_of_protected_member
// ignore: must_be_immutable
class Home extends StatefulWidget {
  Home({ Key? key }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _ctrl = Get.put(Controller());

  late GoogleMapController mapController;

  final Location location = Location();

  // LatLng home = const LatLng(16.807861, 96.129943);
  LatLng home = const LatLng(16.773110, 96.159449);
  late LatLng myLocation;
 //testing
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setMarkers(position: home);
    // location.onLocationChanged.listen((l) { 
    //   log.e( ' ${l.latitude} ${l.longitude}');
    //   mapController.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(target: LatLng(l.latitude as double, l.longitude as double),zoom: 15),
    //     ),
    //   );
    // });
  }
  
  setMarkers({required LatLng position,String id="Home"}) {
    _ctrl.markers.add(
      Marker(
        markerId: MarkerId(id),
        position: position,
        infoWindow: InfoWindow(
          title: id,
          // snippet: "Home Sweet Home",
        ),
      ),
    );
  }

  setPolyLines(List<LatLng> polyPoints) {
    Polyline polyline = Polyline(
      polylineId: const PolylineId("polyline"),
      color: Colors.lightBlue,
      points: polyPoints,
    );
    // _ctrl.polyLines.value.clear();
    Set<Polyline> temp={};
    temp.add(polyline);
    _ctrl.polyLines(temp);
  }
    
  void getLocation () async{
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
     _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    myLocation = LatLng(_locationData.latitude as double, _locationData.longitude as double);
      setMarkers(position: myLocation);
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(_locationData.latitude as double, _locationData.longitude as double),zoom: 15),
        ),
      );
      log.e( ' ${_locationData.latitude} ${_locationData.longitude}');
  }

  @override
  void initState() {
    myLocation = home;
    location.enableBackgroundMode(enable: true);
    getLocation();
    // location.onLocationChanged.listen((LocationData currentLocation) {
    //   myLocation = LatLng(currentLocation.latitude as double, currentLocation.longitude as double);
    //   setMarkers(position: myLocation);
    //   mapController.animateCamera(
    //     CameraUpdate.newCameraPosition(
    //       CameraPosition(target: LatLng(currentLocation.latitude as double, currentLocation.longitude as double),zoom: 15),
    //     ),
    //   );
    //   log.e( ' ${currentLocation.latitude} ${currentLocation.longitude}');
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Center(
          child: Obx( ()=> GoogleMap(
            initialCameraPosition: CameraPosition(
              target: home,
              zoom: 15
            ),
            onMapCreated: _onMapCreated,
            markers: _ctrl.markers.value,
            polylines: _ctrl.polyLines.value,
            onTap: (value){
              if(_ctrl.startBtn.isTrue){
                _ctrl.markers.clear();
                _ctrl.startLat( double.parse(value.latitude.toStringAsFixed(6)) );
                _ctrl.startLng( double.parse(value.longitude.toStringAsFixed(6)) );
                setMarkers(position: value,id: 'Start');
                _ctrl.startBtn(false);
              }else if(_ctrl.endBtn.isTrue){
                _ctrl.markers.clear();
                _ctrl.endLat( double.parse(value.latitude.toStringAsFixed(6)) );
                _ctrl.endLng( double.parse(value.longitude.toStringAsFixed(6)) );
                setMarkers(position: value,id: 'End');
                _ctrl.endBtn(false);
              }else if(_ctrl.pointBtn.isTrue){
                if(_ctrl.points.value.isEmpty){
                  // _ctrl.markers.clear();
                }
                List<LatLng> temp = [];
                temp.addAll(_ctrl.points.value);
                int num = temp.length+1;
                setMarkers(position: value,id: 'Point$num');
                temp.add(value);
                _ctrl.points(temp);
              }
              // setMarkers(
              //   position: value,
              //   id: value.toString()
              // );
            },
          ),)
        ),
        Obx( ()=> dash() ),
      ],),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          String profile = 'driving-car'; // 'driving-car'; foot-walking
          String apiKey = '5b3ce3597851110001cf62482bcc530e03734e74af9f467ae3294ab9';
          // LatLng start = LatLng( _ctrl.startLat.value, _ctrl.startLng.value);
          // LatLng end = LatLng( _ctrl.endLat.value, _ctrl.endLng.value);
          // OpenRoute.getDirection(profile: profile, apiKey: apiKey, start: start, end: end)
          // .then((value){
          //   setPolyLines(value);
          //   log.d(value.length);
          // }).onError((error, stackTrace){
          //   log.e((error as DioError).response);
          // });
          
          // List<LatLng> destinations = const[
          //   LatLng(16.801432, 96.137718), // ပြည်သူ့ဥယျဉ်
          //   LatLng(16.801022, 96.125984), // ကျောင်းရှေ့မှတ်တိုင်(အောက်ကြည်မြင်တိုင်)
          //   LatLng(16.796844, 96.131369), // ဗဟိုရ်လမ်း/ရှင်စောပု
          //   LatLng(16.788941, 96.141559), // အမျိုးသားပြတိုက်/ပြည်လမ်း
          //   LatLng(16.782688, 96.137000), // မင်းရဲကျော်စွာလမ်း
          //   LatLng(16.800909, 96.149178), // ရွှေတြိဂုံဘုရား
          //   LatLng(16.779432, 96.154276), // Junction City ဗိုလ်ချုပ်လမ်း
          // ];
          // // shuffle for develop state
          // List<int> temp = List<int>.generate(
          //   destinations.length, (index) => index
          // );
          // temp.shuffle();
          // List<LatLng> dest = List<LatLng>.generate(
          //   temp.length, (index) => destinations[temp[index]]
          // );
          // destinations=dest;
          // // develop state

          // OpenRoute.getDirection(profile: profile, apiKey: apiKey, 
          //   start: LatLng(_ctrl.startLat.value, _ctrl.startLng.value),
          //   end: LatLng(_ctrl.endLat.value, _ctrl.endLng.value)
          // ).then((value){
          //   setPolyLines(value);
          // }).onError((error, stackTrace){
          //   log.e((error as DioError).response);
          // });

          // sort route testing

          // OpenRoute.sortRoute(
          //   apiKey: apiKey,
          //   profile: profile,
          //   home: LatLng(_ctrl.startLat.value, _ctrl.startLng.value),
          //   destinations: _ctrl.points.value
          // )
          // .then((value){
            // // redraw maker
            // _ctrl.markers.clear();
            // for(int a=0;a<value.length;a++){
            //   setMarkers(position: value[a],id: a==0?'start':'point $a');
            // }
            // // redraw maker
            // OpenRoute.directionGeoJson(profile: profile, apiKey: apiKey, 
            //   coordinates: value
            // ).then((value){
            //   setPolyLines(value);
            // }).onError((error, stackTrace){
            //   log.e(error);
            // });
          // });

          // generate RxList to List
          List<GroupRoute> groupRoutes = List<GroupRoute>.generate(
            _ctrl.groupRoutes.length,
            (i) => GroupRoute(
              primary: _ctrl.groupRoutes.value[i].primary,
              secondary: _ctrl.groupRoutes.value[i].secondary
            )
          );

          OpenRoute.groupRoute(
            apiKey: apiKey, 
            profile: profile, 
            myLocation: myLocation, 
            groupRoutes: groupRoutes,
          ).then((value){
            // redraw maker
            _ctrl.markers.clear();
            for(int a=0;a<value.length;a++){
              setMarkers(position: value[a],id: a==0?'start':'point $a');
            }
            // redraw maker
            OpenRoute.directionGeoJson(profile: profile, apiKey: apiKey, 
              coordinates: value
            ).then((value){
              setPolyLines(value);
            }).onError((error, stackTrace){
              log.e(error);
            });
            log.e(value.length);
          });

        },
        child: const Icon(Icons.search),
      ),
    );
  }

  Widget dash()=>SafeArea(
    child: Column(children: [
      Row(children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 40.0,
            child: ElevatedButton(
              onPressed: (){
                if(_ctrl.startBtn.isTrue){
                  _ctrl.startBtn(false);
                }else{
                  _ctrl.endBtn(false);
                  _ctrl.pointBtn(false);
                  _ctrl.startBtn(true);
                }
              },
              child: const Text('Start'),
              style: ElevatedButton.styleFrom(
                primary: _ctrl.startBtn.isTrue?Colors.amber:Colors.blue,
              ),
            ),
          )
        ),
        Expanded(
          flex: 2,
          child: Container(
            height: 40.0,
            color: Colors.white,
            alignment: Alignment.center,
            child: Text('${_ctrl.startLat} , ${_ctrl.startLng}'),
          )
        ),
      ],),
      Row(children: [
        Expanded(
          flex: 1,
          child: SizedBox(
            height: 40.0,
            child: ElevatedButton(
              onPressed: (){
                if(_ctrl.endBtn.isTrue){
                  _ctrl.endBtn(false);
                }else{
                  _ctrl.startBtn(false);
                  _ctrl.pointBtn(false);
                  _ctrl.endBtn(true);
                }
              },
              child: const Text('End'),
              style: ElevatedButton.styleFrom(
                primary: _ctrl.endBtn.isTrue?Colors.amber:Colors.blue,
              ),
            ),
          )
        ),
        Expanded(
          flex: 2,
          child: Container(
            height: 40.0,
            color: Colors.white,
            alignment: Alignment.center,
            child: Text('${_ctrl.endLat} , ${_ctrl.endLng}'),
          )
        ),
      ],),
      Row(children: [
        Expanded(
          flex: 4,
          child: SizedBox(
            height: 40.0,
            child: ElevatedButton( 
              onPressed: (){
                if(_ctrl.pointBtn.isTrue){
                  _ctrl.pointBtn(false);
                }else{
                  _ctrl.pointBtn(true);
                  _ctrl.startBtn(false);
                  _ctrl.endBtn(false);
                }
              },
              child: const Text('Point'),
              style: ElevatedButton.styleFrom(
                primary: _ctrl.pointBtn.isTrue?Colors.amber:Colors.blue,
              ),
            ),
          )
        ),
        Expanded(
          flex: 4,
          child: Container(
            height: 40.0,
            color: Colors.white,
            alignment: Alignment.center,
            child: Text('point: ${_ctrl.points.value.length} | gp: ${_ctrl.groupRoutes.length}'),
          )
        ),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 40.0,
            child: ElevatedButton(
              onPressed: (){
                if(_ctrl.startLat.value !=0.0 &&_ctrl.startLng.value!=0.0 && _ctrl.points.length>0){
                  GroupRoute groupRoute = GroupRoute(
                    primary: LatLng(_ctrl.startLat.value,_ctrl.startLng.value),
                    secondary: _ctrl.points
                  );
                  _ctrl.groupRoutes.add(groupRoute);

                  // _ctrl.startLat(0.0);_ctrl.startLng(0.0);_ctrl.endLat(0.0);_ctrl.endLng(0.0);
                  // _ctrl.points(<LatLng>[]);
                  // _ctrl.polyLines.clear();
                  // _ctrl.markers.clear();
                }else{
                  log.e('error');
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.pink
              ),
              child: const Icon(Icons.add),
            ),
          )
        ),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 40.0,
            child: IconButton(
              onPressed: (){
                _ctrl.startLat(0.0);_ctrl.startLng(0.0);_ctrl.endLat(0.0);_ctrl.endLng(0.0);
                _ctrl.points(<LatLng>[]);
                _ctrl.groupRoutes.clear();
                _ctrl.polyLines.clear();
                _ctrl.markers.clear();
              },
              icon: const Icon(Icons.close),
            ),
          )
        )
      ],)
    ],),
  );
}
class Controller extends GetxController{
  RxSet<Marker> markers = <Marker>{}.obs;
  RxSet<Polyline> polyLines = <Polyline>{}.obs;

  RxBool startBtn=false.obs;
  RxBool endBtn=false.obs;
  RxBool pointBtn=false.obs;
  RxDouble startLat = 0.0.obs;
  RxDouble startLng = 0.0.obs;
  RxDouble endLat = 0.0.obs;
  RxDouble endLng = 0.0.obs;
  RxList<LatLng> points = <LatLng>[].obs;

  // Group route
  RxList<GroupRoute> groupRoutes= <GroupRoute>[].obs;
  // Group route


  List test = [
    {
      'home': {
        'lat': '96.06565',
        'lng': '18.1545',
      },
      'dist': [
        {
        'lat': '96.06565',
        'lng': '18.1545',
        },
        {
        'lat': '96.06565',
        'lng': '18.1545',
        },
        {
        'lat': '96.06565',
        'lng': '18.1545',
        },
      ]
    },
    {
      'home': {
        'lat': '96.06565',
        'lng': '18.1545',
      },
      'dist': [
        {
        'lat': '96.06565',
        'lng': '18.1545',
        },
        {
        'lat': '96.06565',
        'lng': '18.1545',
        },
        {
        'lat': '96.06565',
        'lng': '18.1545',
        },
      ]
    },
  ];
}

// class GroupRoute extends GetxController{
//   LatLng primary;
//   List<LatLng> secondary;
//   GroupRoute({required this.primary,required this.secondary});
// }


// note

// https://levelup.gitconnected.com/how-to-add-google-maps-in-a-flutter-app-and-get-the-current-location-of-the-user-dynamically-2172f0be53f6