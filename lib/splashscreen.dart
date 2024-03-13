import 'package:flutter/material.dart';
import 'routepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 10)).then((value) =>
      Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RoutePage(title: "Route Page"))));
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(58, 102, 128, 1.0),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Container(
                    // height: 180,
                    // width: 180,
                    height: 372,
                    width: 550,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/logo.gif'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    children: const [
                      Text(
                        "Version",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        "1.0.0",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),

                ],
              ),
            ),
            Container(
              height: 630,
            ),
          ],
        )
      )
    );
  }
}
