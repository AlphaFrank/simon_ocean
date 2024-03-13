import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<EventPage> createState() => _EventState();
}

class _EventState extends State<EventPage> {
  var testList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  testList = [];
                  FirebaseFirestore.instance.collection("Test").get()
                      .then((querySnapshot){
                    print("Successfully loaded");
                    querySnapshot.docs.forEach((element){
                      print(element.data()['name']);
                      print(element.data()['age']);
                      testList.add(element.data()['name'] + " (" + element.data()['age'] + ")");
                    });
                    setState(() {

                    });
                  }).catchError((error){
                    print("Failed loading");
                    print(error.toString());
                  });
                },
                child: Text("View Test")
            ),

            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: testList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 50,
                        color: Colors.amber[500],
                        child: Center(child: Text('Test: ${testList[index]}')),
                      );
                    }
                )
            )
          ],
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
