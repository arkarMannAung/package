import 'dart:math';
import 'package:flutter/material.dart';
import 'package:open_route_api/open_route_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
// ignore_for_file: invalid_use_of_protected_member
// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({ Key? key }) : super(key: key);
  final _ctrl = Get.put(Controller());
  late GoogleMapController mapController;
  LatLng home = const LatLng(16.807861, 96.129943);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setMarkers(position: home);
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
          String profile = 'foot-walking'; // 'driving-car';
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

          OpenRoute.getDirection(profile: profile, apiKey: apiKey, 
            start: LatLng(_ctrl.startLat.value, _ctrl.startLng.value),
            end: LatLng(_ctrl.endLat.value, _ctrl.endLng.value)
          ).then((value){
            setPolyLines(value);
          });

          // OpenRoute.sortRoute(
          //   apiKey: apiKey,
          //   profile: profile,
          //   home: LatLng(_ctrl.startLat.value, _ctrl.startLng.value),
          //   destinations: _ctrl.points.value
          // )
          // .then((value){
          //   List<LatLng> polyDatas= <LatLng>[];
          //   polyDatas.add(LatLng(_ctrl.startLat.value, _ctrl.startLng.value));
          //   polyDatas.addAll(List<LatLng>.generate(value.length, (i) => value[i].coordinate));
          //   // redraw maker
          //   _ctrl.markers.clear();
          //   for(int a=0;a<polyDatas.length;a++){
          //     setMarkers(position: polyDatas[a],id: a==0?'start':'point $a');
          //   }
          //   // redraw maker
          //   OpenRoute.directionGeoJson(profile: profile, apiKey: apiKey, 
          //     coordinates: polyDatas
          //   ).then((value){
          //     setPolyLines(value);
          //   }).onError((error, stackTrace){
          //     log.e(error);
          //   });
            
            
          //   for (var element in value) {
          //     log.e('dis: ${element.distance} long:${element.coordinate.longitude}');
          //   }
          // });
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
          flex: 6,
          child: Container(
            height: 40.0,
            color: Colors.white,
            alignment: Alignment.center,
            child: Text('point: ${_ctrl.points.value.length}'),
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
}