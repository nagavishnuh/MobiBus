// ignore_for_file: use_key_in_widget_constructors, unnecessary_null_comparison, deprecated_member_use, prefer_const_constructors, invalid_return_type_for_catch_error, avoid_print

import 'package:flutter/material.dart';
// import 'package:major_project/loginPage.dart';
import 'loginPage.dart';
// import 'package:major_project/reusable_widgets.dart';
import 'reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen(this.user);
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
  String user = "";
}

class _SignUpScreenState extends State<SignUpScreen> {
  String userType = "";
  final _name = TextEditingController();
  final _password = TextEditingController();
  final _email = TextEditingController();
  final _phoneNo = TextEditingController();
  final _driverId = TextEditingController();
  final _routeNo = TextEditingController();
  final _busNo = TextEditingController();
  bool circular = false;

  Future<void> createDriver(String routeNo, String email) async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('createDriver');
    print("Abhiiiiiiii  $email");
    final results = await callable.call(<String, dynamic>{
      'routeNo': routeNo,
      'email': email,
    });
    print("result = ${results.data}");
  }

  Future<void> createPassenger() async {
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('createPassenger');
    final results = await callable();
  }

  @override
  void initState() {
    super.initState();
    userType = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$userType Register",
          style: TextStyle(color: Colors.lightBlue),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.lightBlue,
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: ListView(
          children: getList(),
        ),
      ),
    );
  }

  List<Widget> getList() {
    List<Widget> listItems = [];
    listItems.add(
      CircleAvatar(
        radius: 80.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(90),
          child: Image.asset(
            "images/$userType\Icon.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
    listItems.add(Divider());
    listItems.add(reusableTextField("Enter Name", Icons.person, false, _name));

    listItems.add(Divider());
    listItems.add(
        reusableTextField("Enter UserMail", Icons.mail_outline, false, _email));

    listItems.add(Divider());
    listItems.add(reusableTextField(
        "Enter Password", Icons.lock_outline, true, _password));

    listItems.add(Divider());
    listItems.add(reusableTextField(
        "Enter PhoneNo", Icons.contact_phone, false, _phoneNo));

    listItems.add(Divider());
    if (userType == "Driver") {
      listItems.add(reusableTextField(
          "Enter Driver Id", Icons.numbers_outlined, false, _driverId));
      listItems.add(Divider());
      listItems.add(reusableTextField(
          "Enter Route Number", Icons.numbers_outlined, false, _routeNo));
      listItems.add(Divider());
      listItems.add(reusableTextField("Enter Bus Number",
          Icons.confirmation_number_outlined, false, _busNo));
      listItems.add(Divider());
    }
    listItems.add(firebaseUIButton(context, "Register", () {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _email.text.trim(), password: _password.text)
          .then((value) {
        print("Created New Account");

        if (userType == "Driver") {
          // print(_email.text);
          createDriver(_routeNo.text, _email.text);

          FirebaseFirestore.instance.collection('drivers').add({
            'name': _name.text.trim(),
            'mail': _email.text.trim(),
            'phoneNo': _phoneNo.text.trim(),
            'driverId': _driverId.text.trim(),
            'busNo': _busNo.text.trim(),
            'routeNo': _routeNo.text.trim()
          }).then((value) {
            print("Driver added");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginPage(userType)));
          }).catchError((error) => print("Error to add driver $error"));
        } else {
          createPassenger();
          FirebaseFirestore.instance.collection('travellers').add({
            'name': _name.text.trim(),
            'mail': _email.text.trim(),
            'phoneNo': _phoneNo.text.trim()
          }).then((value) {
            print("Traveller added");
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginPage(userType)));
          }).catchError((error) => print("Error to add traveller $error"));
        }
      }).onError((error, stackTrace) {
        print("Error ${error.toString()}");
      });
    }));
    return listItems;
  }
}
