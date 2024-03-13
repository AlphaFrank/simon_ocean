import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';


class MapPage extends StatefulWidget {
  const MapPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MapPage> createState() => _MapState();
}

class _MapState extends State<MapPage> {
  bool _showMap = false;
  TextEditingController _latController = TextEditingController();
  TextEditingController _lonController = TextEditingController();

  String _materials = '';

  List<Marker> markers = [];


  @override
  void initState() {
    super.initState();
  }

  Future<void> _sentRequest() async {
    String serverUrl = 'https://oceanpollution.marisabelchang.repl.co/predict';
    final url = Uri.parse(serverUrl);
    final headers = {'Content-Type': 'application/json'};

    Map data = {
      'latitude': double.parse(_latController.text),
      'longitude': double.parse(_lonController.text)
    };

    http
        .post(
      url,
      headers: headers,
      body: jsonEncode(data),
    )
        .then((response) {
          if (response.statusCode == 200) {
            Map materials = {};
            materials = jsonDecode(response.body);
            getMaterials(materials);
          } else {
            if (kDebugMode) {
              print('Error sending data');
            }
          }
    });

  }

  void getMaterials(Map<dynamic, dynamic> materials) {
    setState(()
    {
      _materials = '';
      int i=1;
      materials.forEach((material, quantity) {
        if (i%3==0) {
          _materials += '$material: $quantity\n';
        } else {
          _materials += '$material: $quantity     ';
        }
        i++;
      });
    });
    if (kDebugMode) {
      print(_materials);
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are denied.')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
      .then((Position position) {
        setState(() {
          _latController.text = position.latitude.toString();
          _lonController.text = position.longitude.toString();
          _showMap = true;
          _materials = '';
          Marker newMarker = Marker(
            markerId: const MarkerId('marker'),
            position: LatLng(double.parse(_latController.text),
            double.parse(_lonController.text)),
            infoWindow: const InfoWindow(title: 'Your Location'),
          );
          markers.add(newMarker);
        });
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }



  @override
  Widget build(BuildContext context) {
  double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(246, 244, 235, 1),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: <Widget>[
                const Text(
                  "Check Trash",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(fontSize: 40),
                ),
                Container(
                  height: 3,
                  color: const Color.fromRGBO(50, 50, 50, 1),
                ),
                buildLocator(),
                _showMap
                  ? Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                const Color.fromRGBO(116, 155, 194, 1)
                            ),
                            onPressed: _sentRequest,
                            child: const Text('Check')
                          ),
                          buildGoogleMap(height)
                        ],
                  )
                    : const SizedBox(),
                
                Text(_materials)


              ],
            )
          )
        )
      )

    );
  }


  Padding buildLocator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _latController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Lat'),
                hintText: "Latitude",
              )
            ),
          ),
          const SizedBox(
            width: 3,
          ),
          Expanded(
            flex: 2,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _lonController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Lon',
                hintText: "Longitude",
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.gps_fixed),
                  tooltip: 'Find current location',
                  onPressed: (){
                    _getCurrentPosition();
                  },
                ),
                const Text('Your Location', textAlign: TextAlign.center),
              ],
            )
          )
        ],
      )
    );
  }
  SizedBox buildGoogleMap(double height) {
    return SizedBox(
      height: height * .4,
      child: FractionallySizedBox(
        heightFactor: 0.9,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target:LatLng(double.parse(_latController.text),
            double.parse(_lonController.text)),
            zoom:15,
          ),
          markers: Set.from(markers),
        )
      ),
    );
  }
}















