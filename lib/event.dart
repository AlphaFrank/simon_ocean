import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'db.dart';
import 'package:url_launcher/url_launcher.dart';

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
  Map events = {};

  @override
  void initState() {
    super.initState();
    getLogs();
  }

  getLogs() async {
    getEvents().then((value) {
      setState(() {
        events = value!;

      });
    });
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          color: const Color.fromRGBO(246, 244, 235, 1),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: events!.length,
                itemBuilder: (BuildContext context, int index) {
                  String name = events.keys.elementAt(index);
                  return Card(
                    child: Column(
                      children: [
                        Text(
                          events[name]["date"],
                        ),
                        ListTile(
                          title: Text(
                            name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(events[name]['location']),
                        ),
                        createButton("Check it out", events[name]["link"])
                      ]
                    )
                  );

                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              )
            )
          )


        )

      );

  }

  createButton(String text, String url) {
    final Uri _url = Uri.parse(url);
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 28.0, right: 28),
        child: ElevatedButton(
          onPressed: () async {
            if (!await launchUrl(_url)) {
              throw Exception('could not launch.');
            }
          },
          child: Text(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromRGBO(116, 155, 194, 1)
          ),
        )
      )

    );
  }
}
