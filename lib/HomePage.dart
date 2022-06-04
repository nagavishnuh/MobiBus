// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
// import 'package:major_project/loginPage.dart';
import 'loginPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Welcome",
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 40.0),
          color: Colors.lightBlueAccent,
          child: Column(
            children: [
              Text(
                "Choose",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage("Driver")));
                  },
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Driver",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 50.0,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text("Can check the route"),
                            Text("See number of passengers"),
                            Text("Get re-route details")
                          ],
                        ),
                        Flexible(
                          child: Image(
                            image: AssetImage('images/driverIntro.jpg'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage("Traveller")));
                  },
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Traveller",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 50.0,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text("Can check the buses"),
                            Text("Know bus details"),
                            Text("Get driver details"),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                        Flexible(
                          child: Image(
                            image: AssetImage('images/travellerIntro.jpg'),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
