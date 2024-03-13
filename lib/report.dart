import 'package:flutter/material.dart';
import 'package:ocean/addReport.dart';

import 'db.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<ReportPage> createState() => _ReportState();
}

class _ReportState extends State<ReportPage> {

  Map report = {};

  @override
  void initState() {
    super.initState();
    getLogs();
  }

  getLogs() async {
    getReport().then((value) {
      setState(() {
        report = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(246, 244, 235, 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child : ListView(
            children: [
              const Text(
                "Ocean Debris Report",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(50, 50, 50, 1),
                ),
              ),
              Container(
                height:3,
                color: const Color.fromRGBO(50, 50, 50, 1),
              ),
              SizedBox(height: 10,),
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: report!.length,
                itemBuilder: (BuildContext context, int index) {
                  String date = report.keys.elementAt(index);
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                            date,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "lat: ${report[date]['lat']}, lon: ${report[date]['lon']}"
                          ),
                        ),
                        Image.network(
                          report[date]['image'],
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                        SizedBox(
                          height: 10,
                        )
                      ],
                    )
                  );
                },
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(116, 155, 194, 1),
        child: const Icon(Icons.add_location_alt_outlined),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddReportPage(title: 'AddReport')))
              .then((value) => getLogs());
          },
      ),
    );
  }
}
