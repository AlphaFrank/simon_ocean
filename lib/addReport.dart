import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ocean/db.dart';

class AddReportPage extends StatefulWidget {
  const AddReportPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<AddReportPage> createState() => _AddReportState();
}

class _AddReportState extends State<AddReportPage> {

  final ImagePicker _picker = ImagePicker();
  File? _image;
  TextEditingController _latController = TextEditingController();
  TextEditingController _lonController = TextEditingController();
  bool _showMap = false;

  @override
  void initState() {
    super.initState();
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
      });
    }).catchError((e) {
      debugPrint(e.toString());
    });
  }

  _imgFromCamera() async {
    final image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
  }

  _imgFromGallery() async {
    final image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
  }

  void _showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )
            )
          );

      },
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Image.asset(
            'images/replace.png',
            height: 100,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text("Do you want to change the current Image?"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _image = null;
                Navigator.of(context).pop();
                _showPicker();
              },
              child: const Text("yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("no"),
            )
          ],
        );
      },
    );
  }



  Padding buildImageContainer(double width, double height) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Container(
        width: width,
        height: height * 0.25,
        decoration: const ShapeDecoration(
          color: Colors.white70,
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.0, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        child: _image == null
          ? IconButton(
              icon: const Icon(
                Icons.camera_alt_outlined,
                size: 50,
              ),
          onPressed: () {
                _showPicker();
          },
        )
            : Stack (
          children: [
            Container(
              width: width,
              height: height*0.25,
              decoration: const ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.file(
                  File(_image!.path),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 0,
              child: MaterialButton(
                onPressed: () {
                  _showMyDialog();
                },
                color: const Color.fromRGBO(31, 150, 247, 1),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.edit,
                  size:24,
                ),
              ),
            ),
          ],

        ),



      ),
    );
  }

  snapBarBuilder(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  buildLoading() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        );
      });
  }

  Future<File> changeFileNameOnly(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.rename(newPath);
  }

  uploadReport() {
    DateTime now = new DateTime.now();
    final destination = 'ocean_cleaning/ ${now.toString().substring(0,17)}';

    changeFileNameOnly(_image!, now.toString()).then((filename) {
      FocusScopeNode currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      _image = filename;
      uploadFile(destination, _image!)!.then((snapshot) {
        snapshot.ref.getDownloadURL().then((url) {
          Map report = {
            'lat': _latController.text,
            'lon': _lonController.text,
            'image': url
          };

          buildLoading();
          addReport(report, now.toString()).then((value) {
            Navigator.of(context).pop();
            snapBarBuilder('Report added');
          });
        });
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(246, 244, 235, 1),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 20),
              child: Column(
                children: [
                  const Text(
                    "Report Trash",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(50, 50, 50, 1),
                    ),
                  ),
                  Container(
                    height: 3,
                    color: const Color.fromRGBO(50, 50, 50, 1),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  buildImageContainer(width, height),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
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
                              label: Text('Lon'),
                              hintText: "Longitude",
                            )
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.gps_fixed),
                              tooltip: 'Find current location',
                              onPressed: () {
                                _getCurrentPosition();
                              },
                            ),
                            const Text('Locate'),
                          ],
                        )
                      )

                    ],
                  ),
                  _showMap
                    ? Container(
                    height: height* .35,
                    child: FractionallySizedBox(
                      heightFactor: 0.9,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            double.parse(_latController.text),
                            double.parse(_lonController.text)),
                          zoom: 15,
                        ),
                        markers:{
                          Marker(
                            markerId: MarkerId('marker'),
                            position: LatLng(
                              double.parse(_latController.text),
                              double.parse(_lonController.text)),
                            infoWindow: InfoWindow(
                              title: 'Your Location',
                            ),
                          ),
                        },
                      ),
                    ),
                  )
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(top:20),
                    child: _image == null ||
                      _latController.text.isEmpty ||
                      _lonController.text.isEmpty
                      ? null
                        : ElevatedButton(
                      onPressed: () {
                        //print("pressed");
                        uploadReport();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                          const Color.fromRGBO(116, 155, 194, 1)),
                      child: const Text(
                        "Report",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                        ),
                      )
                    )
                  )
                ]
              )
            )
          ],
        )
      )

    );
  }
}
