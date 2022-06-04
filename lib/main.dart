// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, iterable_contains_unrelated_type

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
// import 'package:major_project/HomePage.dart';
import 'HomePage.dart';
// import 'package:major_project/traveller/traveller_homepage.dart';
import 'traveller/traveller_homepage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'driver/driver_homepage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (FirebaseAuth.instance.currentUser != null)
    await FirebaseAuth.instance.currentUser!.getIdTokenResult(true);

  print(FirebaseAuth.instance.currentUser);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Nodo',
      // theme: ThemeData(primarySwatch: Colors.yellow),
      debugShowCheckedModeBanner: false,
      home: AnimatedSplashScreen(
        centered: false,
        // duration: 8800,
        duration: 2000,
        splash: Container(
          margin: EdgeInsets.fromLTRB(0, 200.0, 0.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              Image(
                height: 250.0,
                width: 250.0,
                image: AssetImage('images/bus.gif'),
              ),
              SizedBox(
                height: 200.0,
              ),
              Center(
                child: Text(
                  'BUS NODO',
                  style: TextStyle(
                    fontSize: 40.0,
                    letterSpacing: 2.0,
                    color: Colors.blue[300],
                  ),
                ),
              ),
            ],
          ),
        ),
        splashIconSize: 800.0,
        nextScreen: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Something went wrong"),
              );
            } else if (snapshot.hasData) {
              final currentUser = FirebaseAuth.instance.currentUser!;
              String userType = currentUser.email!;

              // print(currentUser.email!);
              // var res = FirebaseFirestore.instance
              //     .collection('drivers')
              //     .snapshots()
              //     .listen((event) {
              //   print(event.docs.contains(currentUser.email));
              //   if (event.docs.contains(currentUser.email)) {
              //     // print("Inside if");
              //     userType = "Driver";
              //   } else {
              //     // print("Inside else");
              //     userType = "Traveller";
              //   }
              // });
              // print(currentUser.email);
              // FirebaseFirestore.instance
              //     .collection('drivers')
              //     .where('mail', isEqualTo: currentUser.email)
              //     .get()
              //     .then((value) {
              //   // print("Driver");
              //   userType = "Driver";
              // }).onError((error, stackTrace) {
              //   // print("Traveller");
              //   userType = "Traveller";
              // });
              if (userType == "traveller") {
                return TravellerHomePage();
              } else {
                // print("True");
                return DriverHomePage();
              }
            } else {
              return HomePage();
            }
          },
        ),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
      ),
      routes: {
        '/homepage': (context) => HomePage(),
      },
    );
  }
}
