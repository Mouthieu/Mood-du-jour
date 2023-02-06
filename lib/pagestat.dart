import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'moodata.dart';

class PageStat extends StatefulWidget {
  const PageStat({super.key});

  @override
  State<PageStat> createState() => _PageStatState();
}

class _PageStatState extends State<PageStat> {
  late Box _boite;

  openBoite() async {
    _boite = Hive.box('Boite');
  }

  void clear() async {
    await _boite.clear();
  }

  @override
  void initState() {
    super.initState();
    // Get reference to an already opened box
    // openBoite();
  }

  @override
  Widget build(BuildContext context) {
    _boite = Hive.box('Boite');
    return Scaffold(
      body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                Colors.orange.withOpacity(0.8),
                Colors.purple,
                Colors.cyan.withOpacity(0.7)
              ])),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text(
              "Statistiques",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Kingsman Demo', fontSize: 60),
            ),
            const SizedBox(
              height: 80,
            ),
            SizedBox(
                width: double.infinity,
                height: 450,
                child: SfCartesianChart(
                    // Initialize category axis
                    backgroundColor: Colors.white,
                    borderColor: Colors.black,
                    primaryXAxis: CategoryAxis(
                      maximum: _boite.keys.last.toDouble() - 1,
                      minimum: 0,
                    ),
                    primaryYAxis: CategoryAxis(maximum: 4, minimum: 1),
                    series: <LineSeries<Moodata, int>>[
                      LineSeries<Moodata, int>(
                          // Bind data source
                          dataSource: <Moodata>[
                            for (int i = 1; i <= _boite.keys.length; i++)
                              Moodata(_boite.keys.elementAt(i - 1),
                                  _boite.values.elementAt(i - 1))
                          ],
                          xValueMapper: (Moodata humeur, _) => humeur.jour,
                          yValueMapper: (Moodata humeur, _) => humeur.humeur)
                    ])),
            const SizedBox(height: 80),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.withOpacity(0.6),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.all(8.0),
                    minimumSize: const Size(160, 80)),
                onPressed: () => {Navigator.pop(context)},
                child: const Text(
                  "Retour",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Comforta', fontSize: 30),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () => clear(),
                  icon: const Icon(Icons.recycling_rounded),
                )
              ],
            )
          ])),
    );
  }
}
