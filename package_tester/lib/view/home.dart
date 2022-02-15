import 'dart:math';

import 'package:flutter/material.dart';
import 'package:open_route_api/open_route_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';

class Home extends StatelessWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Testing')),
      body: Column(children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: (){
                String profile = 'driving-car';
                String apiKey = '5b3ce3597851110001cf62482bcc530e03734e74af9f467ae3294ab9';
                LatLng start = const LatLng(16.838094,96.243881);
                LatLng end = const LatLng(16.778769, 96.170669);
                // OpenRoute.getDirection(profile: profile, apiKey: apiKey, start: start, end: end)
                // .then((value){
                //   log.d(value.length);
                // }).onError((error, stackTrace){
                //   log.e((error as DioError).response);
                // });
                LatLng home = const LatLng(16.807861, 96.129943);
                List<LatLng> destinations = const[
                  LatLng(16.801432, 96.137718), // ပြည်သူ့ဥယျဉ်
                  LatLng(16.801022, 96.125984), // ကျောင်းရှေ့မှတ်တိုင်(အောက်ကြည်မြင်တိုင်)
                  LatLng(16.796844, 96.131369), // ဗဟိုရ်လမ်း/ရှင်စောပု
                  LatLng(16.788941, 96.141559), // အမျိုးသားပြတိုက်/ပြည်လမ်း
                  LatLng(16.782688, 96.137000), // မင်းရဲကျော်စွာလမ်း
                  LatLng(16.800909, 96.149178), // ရွှေတြိဂုံဘုရား
                  LatLng(16.779432, 96.154276), // Junction City ဗိုလ်ချုပ်လမ်း
                ];
                // shuffle for develop state
                List<int> temp = List<int>.generate(
                  destinations.length, (index) => index
                );
                temp.shuffle();
                List<LatLng> dest = List<LatLng>.generate(
                  temp.length, (index) => destinations[temp[index]]
                );
                destinations=dest;
                // develop state

                OpenRoute.sortRoute(
                  apiKey: apiKey,
                  profile: profile,
                  home: home,
                  destinations: destinations
                )
                .then((value){
                  for (var element in value) {
                    log.e('dis: ${element.distance} long:${element.coordinate.longitude}');
                  }
                });
              },
              child: const Text('Test')
            ),
          ],mainAxisAlignment: MainAxisAlignment.center,
        )
      ],mainAxisAlignment: MainAxisAlignment.center,),
    );
  }
}