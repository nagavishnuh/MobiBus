// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:major_project/driver/location_tracking.dart';
import 'location_tracking.dart';
// import 'package:major_project/HomePage.dart';
import 'driverRouteMap.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({Key? key}) : super(key: key);

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  List driverDetails = [];
  final currentUser = FirebaseAuth.instance.currentUser!;
  Future<void> getDriverDetails() async {
    await FirebaseFirestore.instance
        .collection('drivers')
        .where('mail', isEqualTo: currentUser.email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        driverDetails.add({
          'routeNo': doc['routeNo'],
          'driverId': doc['driverId'],
          'busNo': doc['busNo'],
        });
      });
    });
    // FirebaseFirestore.instance.collection('startedBuses').add({
    //   // 'routeNo' = driverDetails['routeNo'],
    // }
    // )
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome to App",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.person_outlined,
              color: Colors.black,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
        ),
      ),
      drawer: getSideBar(currentUser, context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Ready for the Trip?",
            style: TextStyle(fontSize: 30.0),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DriverRoute()));
              },
              child: Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(360.0),
                    color: Colors.red),
                child: Center(
                    child: Text(
                  "START",
                  style: TextStyle(color: Colors.white, fontSize: 40.0),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Drawer getSideBar(User currentUser, BuildContext context) {
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Colors.yellow[400]),
            accountName: Text(
              currentUser.email!,
              style: TextStyle(color: Colors.black),
            ),
            accountEmail: Text(
              currentUser.email!,
              style: TextStyle(color: Colors.black),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'images/TravellerIcon.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
          ),
          getSideBarOption(Icons.mail, 'Contact Us', () {}),
          Divider(),
          getSideBarOption(Icons.exit_to_app, 'Logout', () {
            FirebaseAuth.instance.signOut();
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  ListTile getSideBarOption(IconData icon, String text, Function onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () => onTap(),
    );
  }
}
