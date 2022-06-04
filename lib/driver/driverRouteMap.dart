import 'package:bus_pool/driver/location_tracking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapApi {
  // String _url = "AIzaSyCiWOiuKnCmdCZ-3ErnrJ5WoXjGqeslitM";\
  String _url = "AIzaSyCiWOiuKnCmdCZ-3ErnrJ5WoXjGqeslitM";
  String get url => _url;
}

class DriverRoute extends StatefulWidget {
  const DriverRoute({Key? key}) : super(key: key);

  @override
  State<DriverRoute> createState() => _DriverRouteState();
}

class _DriverRouteState extends State<DriverRoute> {
  String routeNo = '104';
  bool isTrue = false;
  List finalDetails = [];
  List stopDetails = [];
  var res;
  void getRoute() async {
    await FirebaseFirestore.instance
        .collection("stopsWithLatLon")
        .get()
        .then((QuerySnapshot querySnapShot) {
      querySnapShot.docs.forEach((element) {
        if (element['routeNo'].toString().compareTo(routeNo.toString()) == 0) {
          stopDetails = element['stopLatLon'];

          // print("Abhiiiiii $stopDetails");
        } else {
          print("Nothing found");
        }
      });
    }).then((value) {
      for (var stop in stopDetails) {
        // print(stop);
        finalDetails.add({
          'busStopName': stop['busstop'],
          'latlons': LatLng(double.parse(stop['latlons'][0]),
              double.parse(stop['latlons'][1]))
        });
      }
      setState(() {
        isTrue = true;
      });
    });
    // stopDetails = res['stopLatLon'];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRoute();
  }

  @override
  Widget build(BuildContext context) {
    if (!isTrue) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      );
    } else {
      print("Abhiiiiiiiiii   $finalDetails");
      return LocationTracking(finalDetails);
    }
  }
}
