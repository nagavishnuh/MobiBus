// ignore_for_file: prefer_const_constructors, file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:major_project/googleSignIn.dart';
// import 'package:major_project/loggedIn.dart';
import 'package:provider/provider.dart';
import 'reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signupPage.dart';
import 'driver/driver_homepage.dart';
import 'traveller/traveller_homepage.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
  LoginPage(this.user);
  String user;
}

// String userType = "";

class _LoginPageState extends State<LoginPage> {
  String userType = "";
  final _passwordTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
    userType = widget.user;
  }

  Widget photoFun() {
    if (userType == "Driver") {
      return Image(
        height: 200,
        width: 200,
        image: AssetImage("images/driverIntro.jpg"),
      );
    } else {
      return Image(
        height: 200,
        width: 200,
        image: AssetImage("images/travellerIntro.jpg"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(color: Colors.lightBlue),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.lightBlue,
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        child: ListView(
          children: [
            Center(
              child: Text(
                "Hello $userType",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            photoFun(),
            SizedBox(height: 40.0),
            reusableTextField("Enter UserMail", Icons.mail_outline, false,
                _emailTextController),
            const SizedBox(
              height: 20,
            ),
            reusableTextField("Enter Password", Icons.lock_outline, true,
                _passwordTextController),
            const SizedBox(
              height: 20,
            ),
            firebaseUIButton(context, "Log In", () {
              FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: _emailTextController.text,
                      password: _passwordTextController.text)
                  .then((value) {
                if (userType == "Driver") {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DriverHomePage()));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TravellerHomePage()));
                }
              }).onError((error, stackTrace) {
                print("Error ${error.toString()}");
              });
            }),
            signUpOption(),
          ],
        ),
      ),
    );
  }

  // ElevatedButton googleSignIn() {
  //   return ElevatedButton.icon(
  //     style: ElevatedButton.styleFrom(
  //       primary: Colors.white,
  //       onPrimary: Colors.black,
  //       minimumSize: Size(double.infinity, 50.0),
  //     ),
  //     icon: FaIcon(
  //       FontAwesomeIcons.google,
  //       color: Colors.lightBlueAccent,
  //     ),
  //     label: Text("Sign Up with Google"),
  //     onPressed: () async {
  //       final provider =
  //           Provider.of<GoogleSignInProvider>(context, listen: false);
  //       await provider.googleLogin();
  //     },
  //   );
  // }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.white70)),
        GestureDetector(
          onTap: () {
            print(userType);
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SignUpScreen(userType)));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
        )
      ],
    );
  }
}
