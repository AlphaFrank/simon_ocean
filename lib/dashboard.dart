import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<DashboardPage> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardPage> {
  String text =
    '''- There is an estimated 75 to 199 million tons of plastic waste currently in our oceans, with a further 33 billion pounds of plastic entering the marine environment every single year.
- 100 million marine animals die each year from plastic waste alone.
- 100,000 marine animals die from getting entangled in plastic yearly – this is just the creatures we find!
- 1 in 3 marine mammal species get found entangled in litter, 12-14,000 tons of plastic are ingested by North Pacific fish yearly.
- In the past 10 years, we’ve made more plastic than the last century. By 2050, the pollution of fish will be outnumbered by our dumped plastic.
- The largest trash site on the planet is the Great Pacific Garbage Patch, twice the surface area of Texas, it outnumbers sea life there 6 to 1.
- China is ranked #1 for mismanaged waste and plastics. However, the US is in the top 20 with a more significant waste per person contributions.
- 300 Million tons of plastic gets created yearly, and this weighs the same as the entire human population, and 50% is single-use only.
- There are 5.25 trillion pieces of plastic waste estimated to be in our oceans. 269,000 tons float, 4 billion microfibers per km² dwell below the surface.
- 70% of our debris sinks into the ocean's ecosystem, 15% floats, and 15% lands on our beaches.
- In terms of plastic, 8.3 million tons are discarded in the sea yearly. Of which, 236,000 are ingestible microplastics that marine creatures mistake for food.
- Plastics take 500-1000 years to degrade; currently 79% is sent to landfills or the ocean, while only 9% is recycled, and 12% gets incinerated.''';
  List<String> statistics = [
    '75',
    '199',
    '33',
    '100',
    'million',
    'billion',
    '100,000',
    '12-14,000',
    '1',
    '3',
    '10',
    '2050',
    'twice',
    '20',
    '300',
    '50%',
    '5.25',
    'trillion',
    '269,000',
    '4',
    '70%',
    '15%',
    '8.3',
    '236,000',
    '500-1000',
    '79%',
    '9%',
    '12%'
  ];

  int cleanups_finished = 10;
  int fish_helped = 200;
  int cleanups_to_do = 50;

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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: <Widget>[
                const Text(
                  "Dashboard",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(fontSize: 40),
                ),
                // Container(
                //   height: 3,
                //   color: const Color.fromRGBO(50,50,50,1),
                // ),
                // // const SizedBox(
                // //   height: 10,
                // // ),
                // const Text(
                //   "Upcoming Events",
                //   textAlign: TextAlign.start,
                //   style: TextStyle(
                //     fontSize: 20,
                //     color: Colors.blue,
                //   ),
                // ),
                Container(
                  height: 3,
                  color: const Color.fromRGBO(50,50,50,1),
                ),
                const Text(
                  "History",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blue,
                  ),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: '$cleanups_finished',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                    ),
                    const TextSpan(
                      text: ' Cleanups Finished',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ]),
                ),
                // Text(
                //   '$cleanups_finished Cleanups Finished',
                //   textAlign: TextAlign.start,
                //   style: const TextStyle(
                //     fontWeight: FontWeight.bold,
                //     //fontStyle: FontStyle.italic,
                //     fontSize: 15,
                //   ),
                // ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: '$fish_helped',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.blue,
                      ),
                    ),
                    const TextSpan(
                      text: ' Fish Helped',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ]),
                ),
                // Text(
                //   '$fish_helped Fish Helped',
                //   textAlign: TextAlign.start,
                //   style: const TextStyle(
                //     fontWeight: FontWeight.bold,
                //     //fontStyle: FontStyle.italic,
                //     fontSize: 15,
                //   ),
                // ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                      text: '$cleanups_to_do',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.blue,
                      ),
                    ),
                    const TextSpan(
                      text: ' Cleanups To Do',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ]),
                ),
                // Text(
                //   '$cleanups_to_do Cleanups To Do',
                //   textAlign: TextAlign.start,
                //   style: const TextStyle(
                //     fontWeight: FontWeight.bold,
                //     //fontStyle: FontStyle.italic,
                //     fontSize: 15,
                //   ),
                // ),
                Container(
                  height: 3,
                  color: const Color.fromRGBO(50,50,50,1),
                ),
                const Text(
                  "Statistics & Facts",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                  ),
                ),
                ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: buildRichTextWidgets(),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Source: https://www.condorferries.co.uk/marine-ocean-pollution-statistics-facts',
                    style: TextStyle(fontSize: 8),
                  )
                )

              ],
            ),
          ),
        ),
      ),

    );
  }

  List<Widget> buildRichTextWidgets() {
    List<String> paragraphs = text.split('\n');

    List<Widget> widgets = paragraphs.map((paragraph) {
      List<String> words = paragraph.split(' ');

      List<TextSpan> textSpans = words.map((word) {
        if (statistics.contains(word)) {
          return TextSpan(
            text: word + ' ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          );
        } else {
          return TextSpan(text: word + ' ');
        }

      }).toList();

      return RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: textSpans,
        ),
      );
    }).toList();

    return widgets;
  }
}
