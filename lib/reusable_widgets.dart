// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container firebaseUIButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

Container searchButtons(
    BuildContext context, String title, IconData icon, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 5),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton.icon(
      icon: Icon(
        icon,
        color: Colors.black,
      ),
      onPressed: () {
        onTap();
      },
      label: Text(
        title,
        style: const TextStyle(color: Colors.black87, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
    ),
  );
}

Container getBusCard(String routeNo, String busNo, String noOfSeats,
    String time, Function onTrack) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.black87,
        style: BorderStyle.solid,
        width: 1.5,
      ),
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.directions_bus_filled_outlined,
          color: Colors.black87,
          size: 70.0,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              routeNo,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
            Divider(
              height: 5.0,
            ),
            RichText(
                text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    text: 'Bus No: ',
                    children: <TextSpan>[
                  TextSpan(
                      text: busNo,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0)),
                ])),
            Divider(
              height: 20.0,
            ),
            RichText(
                text: TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    text: 'No of Seats: ',
                    children: <TextSpan>[
                  TextSpan(
                      text: noOfSeats.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0)),
                ])),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
        SizedBox(
          width: 10.0,
        ),
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Arrival Time"),
              Text(
                time,
                style: TextStyle(color: Colors.black, fontSize: 25.0),
              ),
              SizedBox(
                height: 10.0,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    onTrack();
                  },
                  icon: Icon(Icons.search),
                  label: Text("Track")),
            ],
          ),
        )
      ],
    ),
  );
}
