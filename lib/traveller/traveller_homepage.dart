// import 'dart:html';

// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:bus_pool/reusable_widgets.dart';
import 'package:intl/intl.dart';

final List<String> imgList = [
  'https://www.coolztricks.com/wp-content/uploads/2022/04/1-8-241x300.png',
  'https://www.coolztricks.com/wp-content/uploads/2022/04/1-9-230x300.png',
  'https://assets-in.bmscdn.com/iedb/movies/images/mobile/thumbnail/xlarge/kgf-chapter-2-et00098647-08-04-2022-11-33-32.jpg',
  'https://pbs.twimg.com/media/FP6HpAmaAAYRj78?format=jpg&name=large'
];

// int pageIndex = 0;

class TravellerHomePage extends StatefulWidget {
  TravellerHomePage({Key? key}) : super(key: key);

  @override
  State<TravellerHomePage> createState() => _TravellerHomePageState();
}

class _TravellerHomePageState extends State<TravellerHomePage> {
  @override
  final pages = [
    TravIntro(),
    TravSearchByBusNumber(),
    TravSearchRouteBuses(),
  ];
  int pageIndex = 0;
  void setPageIndex(int num) {
    setState(() {
      pageIndex = num;
    });
  }

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
      body: pages[pageIndex],
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
            },
            icon: pageIndex == 0
                ? const Icon(
                    Icons.home_filled,
                    color: Colors.black,
                    size: 35,
                  )
                : const Icon(
                    Icons.home_outlined,
                    color: Colors.black,
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
            },
            icon: pageIndex == 1
                ? const Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 35,
                  )
                : const Icon(
                    Icons.search_outlined,
                    color: Colors.black,
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
              });
            },
            icon: pageIndex == 2
                ? const Icon(
                    Icons.route,
                    color: Colors.black,
                    size: 35,
                  )
                : const Icon(
                    Icons.route_outlined,
                    color: Colors.black,
                    size: 35,
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
          getSideBarOption(Icons.search, 'Search by Bus No.', () {
            setPageIndex(1);
            Navigator.pop(context);
          }),
          getSideBarOption(Icons.route_outlined, 'Search by Route', () {
            setPageIndex(2);
            Navigator.pop(context);
          }),
          getSideBarOption(Icons.favorite, 'Favorite Buses', () {}),
          Divider(),
          getSideBarOption(Icons.mail, 'Contact Us', () {}),
          Divider(),
          getSideBarOption(Icons.exit_to_app, 'Logout', () {
            // print("Done");
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

class TravIntro extends StatefulWidget implements TravellerHomePage {
  @override
  State<TravIntro> createState() => _TravIntroState();
}

class _TravIntroState extends State<TravIntro> {
  final travellerHomePage = TravellerHomePage();
  int _current = 0;

  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow[300],
      padding: EdgeInsets.all(20.0),
      child: ListView(
        children: [
          getCarouselSlider(),
          getCarouselIndicator(context),
          Text(
            "Explore",
            style: TextStyle(
              fontSize: 26.0,
              letterSpacing: 1.0,
              color: Colors.black54,
            ),
          ),
          searchButtons(context, "Search by Bus Number", Icons.search, () {
            // setState(() {
            //   pageIndex = 1;
            // });
          }),
          searchButtons(context, "Search by Source & Destination",
              Icons.route_outlined, () {})
        ],
      ),
    );
  }

  CarouselSlider getCarouselSlider() {
    return CarouselSlider(
      carouselController: _controller,
      items: [
        getImageContainer(
            "https://www.coolztricks.com/wp-content/uploads/2022/04/1-8-241x300.png"),
        getImageContainer(
            "https://www.coolztricks.com/wp-content/uploads/2022/04/1-9-230x300.png"),
        getImageContainer(
            "https://assets-in.bmscdn.com/iedb/movies/images/mobile/thumbnail/xlarge/kgf-chapter-2-et00098647-08-04-2022-11-33-32.jpg"),
        getImageContainer(
            "https://pbs.twimg.com/media/FP6HpAmaAAYRj78?format=jpg&name=large"),
      ],
      options: CarouselOptions(
          height: 370.0,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          viewportFraction: 1.0,
          onPageChanged: (index, reason) {
            setState(() {
              _current = index;
            });
          }),
    );
  }

  Container getImageContainer(String url) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Row getCarouselIndicator(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: imgList.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () => _controller.animateToPage(entry.key),
          child: Container(
            width: 6.0,
            height: 6.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87)
                    .withOpacity(_current == entry.key ? 0.9 : 0.4)),
          ),
        );
      }).toList(),
    );
  }
}

class TravSearchByBusNumber extends StatefulWidget {
  @override
  State<TravSearchByBusNumber> createState() => _TravSearchByBusNumberState();
}

class _TravSearchByBusNumberState extends State<TravSearchByBusNumber> {
  @override
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow[400],
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    icon: Icon(
                      Icons.directions_bus,
                      color: Colors.black87,
                    ),
                    hintText: 'Enter Bus Number',
                    fillColor: Colors.white,
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black38, width: 2.0),
                    ),
                  ),
                  controller: _controller,
                  onTap: () {
                    _controller.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _controller.value.text.length);
                  },
                ),
                searchButtons(context, "Search", Icons.search, () {}),
              ],
            ),
          ),
          getBusCard('103-F', 'KA-06-F-1254', "10", '09:00 AM', () {}),
        ],
      ),
    );
  }
}

class Stop {
  final String name;

  const Stop({
    required this.name,
  });

  static Stop fromJson(Map<String, dynamic> json) => Stop(
        name: json['name'],
      );
}

class TravSearchRouteBuses extends StatefulWidget {
  @override
  State<TravSearchRouteBuses> createState() => _TravSearchRouteBusesState();
}

class _TravSearchRouteBusesState extends State<TravSearchRouteBuses> {
  String source = "";
  String destination = "";
  final _focusNode = FocusNode();
  List<Stop> res = [];
  List finalBuses = [];
  List<Widget> busCards = [];
  final CollectionReference busDetails =
      FirebaseFirestore.instance.collection('busDetails');
  Future<void> fetchAvailableBuses() async {
    final now = DateTime.now();
    // String formatter = DateFormat('Hm').format(now);
    String formatter = '14:00';
    List busStopInfo = [];
    List requriedBuses = [];
    List availableBuses = [];
    finalBuses = [];
    int sourceIdx = 0, destinationIdx = 0;
    try {
      await busDetails
          .where('busstop', arrayContains: source)
          // .where('busStop', arrayContains: destination)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          busStopInfo.add({
            'routeNo': doc['routeNo'],
            'departureFromDestination': doc['departureFromDestination'],
            'departureFromOrigin': doc['departureFromOrigin'],
            'origin': doc['origin'],
            'distance': doc['distance'],
            'duration': doc['duration'],
            'busstop': doc['busstop'],
            'destination': doc['destination']
          });
        });
      });
      for (var doc in busStopInfo) {
        for (var stop in doc['busstop']) {
          if (stop == destination) {
            requriedBuses.add({
              'routeNo': doc['routeNo'],
              'departureFromDestination': doc['departureFromDestination'],
              'departureFromOrigin': doc['departureFromOrigin'],
              'origin': doc['origin'],
              'distance': doc['distance'],
              'duration': doc['duration'],
              'busstop': doc['busstop'],
              'destination': doc['destination']
            });
          }
        }
      }
      int i = 0;
      for (var doc in requriedBuses) {
        for (var stop in doc['busstop']) {
          i += 1;
          if (stop == source) {
            sourceIdx = i;
          }
          if (stop == destination) {
            destinationIdx = i;
          }
        }
        if (sourceIdx < destinationIdx) {
          var timeList = doc['departureFromOrigin'];
          for (var time in timeList) {
            // print(time);
            if (time.compareTo(formatter) > 0) {
              // print(time.compareTo(formatter));
              availableBuses.add({
                'routeNo': doc['routeNo'],
                'deptTime': time,
              });
            }
          }
        } else {
          var timeList = doc['departureFromDestination'];
          for (var time in timeList) {
            // print(time);
            if (time.compareTo(formatter) > 0) {
              // print(time.compareTo(formatter));
              availableBuses.add({
                'routeNo': doc['routeNo'],
                'deptTime': time,
              });
            }
          }
        }
      }
      // for (var doc in availableBuses) {
      //   print(doc);
      // }
      availableBuses.sort((a, b) => a['deptTime'].compareTo(b['deptTime']));
      // print("Hello");
      i = 0;
      for (var bus in availableBuses) {
        i++;
        finalBuses.add(bus);
        if (i == 5) {
          break;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  void getStopsList(List res) async {
    await for (var snapshot
        in FirebaseFirestore.instance.collection('busStops').snapshots()) {
      for (var message in snapshot.docs) {
        res.add(Stop(name: message.data()['name']));
      }
    }
  }

  @override
  void initState() {
    getStopsList(res);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow[400],
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "From",
                  style: TextStyle(color: Colors.black54),
                ),
                getStopTextField(
                    'Enter source', Colors.lightBlue[400], 'source'),
                Divider(
                  thickness: 2.0,
                ),
                Text(
                  "To",
                  style: TextStyle(color: Colors.black54),
                ),
                getStopTextField(
                    'Enter destination', Colors.lightGreen[400], 'destination'),
                searchButtons(context, 'Search', Icons.route, () async {
                  await fetchAvailableBuses();
                  busCards = [];
                  setState(() {
                    for (var bus in finalBuses) {
                      busCards.add(getBusCard(bus['routeNo'].toString(), "NA",
                          "0", bus['deptTime'].toString(), () {}));
                    }
                  });
                }),
              ],
            ),
          ),
          Container(
            child: Column(children: busCards),
          )
        ],
      ),
    );
  }

  Autocomplete<Stop> getStopTextField(
      String hint, Color? color, String chosenStop) {
    return Autocomplete<Stop>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return res
            .where((Stop stop) => stop.name
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase()))
            // .startswith(textEditingValue.text.toLowerCase()))
            .toList();
      },
      displayStringForOption: (Stop option) => option.name,
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        return TextField(
          decoration: InputDecoration(
            filled: true,
            icon: Icon(
              Icons.directions_bus,
              color: color,
            ),
            hintText: hint,
            fillColor: Colors.white,
            hintStyle: TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black38, width: 2.0),
            ),
          ),
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          // onChanged: (text) {
          //   value = text;
          //   print(value);
          // },
          onTap: () {
            fieldTextEditingController.selection = TextSelection(
                baseOffset: 0,
                extentOffset: fieldTextEditingController.value.text.length);
          },
        );
      },
      onSelected: (Stop selection) {
        // print('Selected: ${selection.name}');
        if (chosenStop == "source") {
          setState(() {
            source = selection.name;
          });
        } else {
          setState(() {
            destination = selection.name;
          });
        }
        // print(chosenStop);
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<Stop> onSelected, Iterable<Stop> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            child: Container(
              // margin: EdgeInsets.only(right: 40.0),
              width: 340,
              color: Colors.white,
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final Stop option = options.elementAt(index);

                  return GestureDetector(
                    onTap: () {
                      onSelected(option);
                    },
                    child: ListTile(
                      title: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5.0),
                          // border: Border.all(width: .5)
                        ),
                        child: Text(option.name),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
