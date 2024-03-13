import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Add a test",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700
              ),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Enter name",
                hintStyle: TextStyle(
                    color: Colors.blue.withOpacity(0.6),
                    fontFamily: "Georgia"
                ),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                ),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)
                ),
              ),
              style: const TextStyle(
                  color: Colors.blue,
                  fontFamily: "Georgia"
              ),
            ),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                hintText: "Enter age",
                hintStyle: TextStyle(
                    color: Colors.blue.withOpacity(0.6),
                    fontFamily: "Georgia"
                ),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)
                ),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)
                ),
              ),
              style: const TextStyle(
                  color: Colors.blue,
                  fontFamily: "Georgia"
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  print(nameController.text);
                  print(ageController.text);
                  FirebaseFirestore.instance.collection("Test").add(
                      {
                        "name": nameController.text,
                        "age": ageController.text
                      }
                  ).then((value) {
                    print("Successfully added the test");
                  }).catchError((error) {
                    print("Failed to added the test");
                    print(error.toString());
                  });


                },
                child: Text("Add test")
            )

          ],
        )
    );
  }
}

