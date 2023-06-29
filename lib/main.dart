import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:jumping_dot/jumping_dot.dart';

import 'placeweather.dart';
import 'user_location_weather.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future LocationWeather;
  late double lat;
  late double long;
  late dynamic userLocationWeather;
  late Future<Position> Location;
  @override
  void initState() {
    Initialize();
    super.initState();
  }

  Future<void> Initialize() async {
    Location = getCurrentLocation();
    Position value = await getCurrentLocation();
    lat = value.latitude;
    long = value.longitude;
    getUserLocationWeather();
    LocationWeather = getUserLocationWeather();
  }

  Future<Position> getCurrentLocation() async {
    bool locationServices = await Geolocator.isLocationServiceEnabled();
    if (!locationServices) {
      return Future.error("Location Services is disabled");
    }
    LocationPermission _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
      if (_permission == LocationPermission.denied ||
          _permission == LocationPermission.deniedForever) {
        return Future.error(
            "Location Permission are denied, We can't request Location");
      }
    }
    print("i ran");
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Weather"),
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: CustomSearchDelegate());
                },
                icon: Icon(CupertinoIcons.search))
          ],
        ),
        body: FutureBuilder(
          future: Location,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder(
                future: LocationWeather,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: UserLocationWeather(
                          userLocationWeather: userLocationWeather),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    return Center(
                      child: Row(children: [
                        Text("Getting Weather"),
                        JumpingDots(
                          color: Colors.black,
                        )
                      ]),
                    );
                  }
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              ); //error.png;
            } else {
              return Center(
                  child: Row(
                children: [
                  Text("Getting Location"),
                  JumpingDots(
                    color: Colors.black,
                  )
                ],
              ));
            }
          },
        ));
  }

  Future getUserLocationWeather() async {
    String? api_key = dotenv.env['API_KEY'];
    final String url =
        "http://api.weatherapi.com/v1/forecast.json?key=$api_key&q=$lat,$long&days=7";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final gotUserLocationWeather = json;
    setState(() {
      userLocationWeather = gotUserLocationWeather;
    });
    return gotUserLocationWeather;
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List places = [];
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List matchquery = [];
    getPlaces(query).then((value) {
      places = value;
    });
    for (String name in places) {
      matchquery.add(name);
    }
    return FutureBuilder<List<dynamic>>(
      future: getPlaces(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for data, display a loading indicator
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // If an error occurs while fetching data, display an error message
          return Text('Error: ${snapshot.error}');
        } else {
          // Data has been fetched successfully
          List? places = snapshot.data;
          return ListView.builder(
            itemCount: places?.length,
            itemBuilder: (context, index) {
              String name = places![index];
              return ListTile(
                title: Text(name),
                onTap: () 
                  
                   {
                    getPlaceWeather(name).then((value) =>
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PlaceWeather(weather: value),
                        )));
                  
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List matchquery = [];
    getPlaces(query).then((value) {
      places = value;
    });

    for (String name in places) {
      matchquery.add(name);
    }

    return FutureBuilder<List<dynamic>>(
      future: getPlaces(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for data, display a loading indicator
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // If an error occurs while fetching data, display an error message
          return Center(child: Text('Place Not Found'));
        } else {
          // Data has been fetched successfully
          List? places = snapshot.data;
          return ListView.builder(
            itemCount: places?.length,
            itemBuilder: (context, index) {
              String name = places![index];
              return ListTile(
                title: Text(name),
                onTap: () {
                  getPlaceWeather(name).then(
                      (value) => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PlaceWeather(weather: value),
                          )));
                  ;
                },
              );
            },
          );
        }
      },
    );
  }

  onSelectedResult(String result) {
    print("selected");
  }
}

Future<List> getPlaces(query) async {
  String? api_key = dotenv.env['API_KEY'];
  final String url =
      "http://api.weatherapi.com/v1/search.json?key=$api_key&q=$query";
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  final body = response.body;
  final json = jsonDecode(body);
  List gotplaceList = json.map((e) {
    return "${e['name']}, ${e['country']}";
  }).toList();
  print(gotplaceList);
  return gotplaceList;
}

Future<dynamic> getPlaceWeather(name) async {
  String? api_key = dotenv.env['API_KEY'];
  final String url =
      "http://api.weatherapi.com/v1/forecast.json?key=$api_key&q=$name&days=7&aqi=no&alerts=no";
  final uri = Uri.parse(url);
  final response = await http.get(uri);
  final body = response.body;
  final json = jsonDecode(body);
  final placeWeather = json;
  return placeWeather;
}
