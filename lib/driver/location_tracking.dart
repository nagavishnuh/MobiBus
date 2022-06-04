// ignore_for_file: prefer_const_constructors
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'driverRouteMap.dart';

class LocationTracking extends StatefulWidget {
  // const LocationTracking({Key? key}) : super(key: key);
  LocationTracking(this.coOrdinates);
  List coOrdinates = [];

  @override
  State<LocationTracking> createState() => _LocationTrackingState();
}

class _LocationTrackingState extends State<LocationTracking> {
  LatLng sourceLocation = LatLng(13.3391782, 77.1139872);
  LatLng destinationLatlng = LatLng(13.3381782, 77.1138872);
  List finalLocations = [];

  String routeNo = '1';

  List CoOrdinates = [
    [13.3391782, 77.1139872],
    [13.3371782, 77.1138872],
    [13.3401782, 75.1137872],
    [13.3394782, 76.1138872],
    [14.3394782, 78.1138872],
  ];

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _marker = Set<Marker>();

  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  late StreamSubscription<LocationData> subscription;

  LocationData? currentLocation;
  late LocationData destinationLocation;
  late Location location;

  @override
  void initState() {
    super.initState();
    finalLocations = widget.coOrdinates;
    // getRoute();

    location = Location();
    polylinePoints = PolylinePoints();

    subscription = location.onLocationChanged.listen((clocation) {
      currentLocation = clocation;

      updatePinsOnMap();
    });

    setInitialLocation();
  }

  void setInitialLocation() async {
    await location.getLocation().then((value) {
      currentLocation = value;
      setState(() {});
    });

    destinationLocation = LocationData.fromMap({
      "latitude": destinationLatlng.latitude,
      "longitude": destinationLatlng.longitude,
    });
  }

  void showLocationPins() {
    var sourceposition = LatLng(
        currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0);

    var destinationPosition =
        LatLng(destinationLatlng.latitude, destinationLatlng.longitude);

    _marker.add(Marker(
      markerId: MarkerId('sourcePosition'),
      position: sourceposition,
    ));
    int i = 0;
    for (var stop in finalLocations) {
      i++;
      _marker.add(Marker(
          markerId: MarkerId(stop['busStopName']), position: stop['latlons']));
    }
    _marker.add(
      Marker(
        markerId: MarkerId('destinationPosition'),
        position: destinationPosition,
      ),
    );

    setPolylinesInMap();
  }

  void setPolylinesInMap() async {
    // var result = await polylinePoints.getRouteBetweenCoordinates(
    //   GoogleMapApi().url,
    //   PointLatLng(
    //       currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0),
    //   PointLatLng(destinationLatlng.latitude, destinationLatlng.longitude),
    // );

    // if (result.points.isNotEmpty) {
    //   // print("Entered");
    //   result.points.forEach((pointLatLng) {
    //     polylineCoordinates
    //         .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
    //   });
    // }
    for (int i = 0; i < finalLocations.length - 1; i++) {
      var result = await polylinePoints.getRouteBetweenCoordinates(
        GoogleMapApi().url,
        PointLatLng(finalLocations[i]['latlons'].latitude,
            finalLocations[i]['latlons'].longitude),
        PointLatLng(finalLocations[i + 1]['latlons'].latitude,
            finalLocations[i + 1]['latlons'].longitude),
      );
      if (result.points.isNotEmpty) {
        // print("Entered");
        result.points.forEach((pointLatLng) {
          polylineCoordinates
              .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
        });
      }
    }

    // print(polylineCoordinates);
    setState(() {
      _polylines.add(Polyline(
        width: 5,
        polylineId: PolylineId('polyline'),
        color: Colors.blueAccent,
        points: polylineCoordinates,
      ));
    });
  }

  void updatePinsOnMap() async {
    CameraPosition cameraPosition = CameraPosition(
      zoom: 20,
      target: LatLng(
          currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0),
    );

    final GoogleMapController controller = await _controller.future;

    // controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    var sourcePosition = LatLng(
        currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0);

    setState(() {
      _marker.removeWhere((marker) => marker.mapsId.value == 'sourcePosition');

      _marker.add(Marker(
        markerId: MarkerId('sourcePosition'),
        position: sourcePosition,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom: 20,
      target: currentLocation != null
          ? LatLng(currentLocation!.latitude ?? 0.0,
              currentLocation!.longitude ?? 0.0)
          : LatLng(0.0, 0.0),
    );

    return currentLocation == null
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Scaffold(
              body: GoogleMap(
                myLocationButtonEnabled: true,
                compassEnabled: true,
                markers: _marker,
                polylines: _polylines,
                mapType: MapType.normal,
                initialCameraPosition: initialCameraPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  showLocationPins();
                },
              ),
            ),
          );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
