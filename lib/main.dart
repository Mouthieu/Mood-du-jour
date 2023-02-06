import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:projet_mood/pagestat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  num moyenne = 0;
  int somme = 0;

  // ignore: non_constant_identifier_names
  double taille_boutons = 30;

  late FToast fToast;
  late Box boite;
  Widget toast = Container(
    decoration: const BoxDecoration(
      color: Colors.transparent,
    ),
    child: SizedBox.expand(
        child: Lottie.network(
            'https://assets5.lottiefiles.com/packages/lf20_ylguls7u.json',
            repeat: true)),
  );

  _showToast(int valeur) {
    fToast.showToast(
        child: toast,
        gravity: ToastGravity.CENTER,
        toastDuration: const Duration(milliseconds: 250));
  }

  boxfilling() {
    boite.put(boite.keys.length + 1, moyenne);
  }

  // ignore: non_constant_identifier_names
  void Raz() {
    setState(() {
      _counter = 0;
      somme = 0;
      moyenne = 0;
    });
  }

  _incrementCounter(int note) {
    setState(() {
      _counter++;
      somme += note;
      moyenne = 1000 * somme / _counter;
      moyenne = moyenne.round() / 1000;
    });
  }

  recup() {
    return moyenne;
  }

  verif() {
    if (moyenne != 0) {
      boxfilling();
      Raz();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PageStat()));
    }
    return false;
  }

  openboite() async {
    boite = await Hive.openBox('Boite');
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    openboite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
              Colors.orange.withOpacity(0.8),
              Colors.purple,
              Colors.cyan.withOpacity(0.7)
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Mood Du Jour',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Kingsman Demo",
                fontSize: 100,
              ),
            ),
            const SizedBox(height: 50),
            Text(
              '$moyenne',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 80, fontFamily: 'Questrial'),
            ),
            const SizedBox(height: 50),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              for (int i = 1; i < 5; i++)
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.withOpacity(0.6),
                      shape: const CircleBorder(),
                      minimumSize: Size.fromRadius(taille_boutons),
                    ),
                    onPressed: () => {
                          _showToast(i),
                          _incrementCounter(i),
                        },
                    child: Text(
                      "$i",
                      style: TextStyle(fontSize: taille_boutons - 5),
                    )),
            ]),
            const SizedBox(height: 60),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.withOpacity(0.6),
                    minimumSize: const Size(140, 60),
                    shape: const StadiumBorder()),
                onPressed: () {
                  verif();
                },
                child: const Text(
                  "Valider",
                  style: TextStyle(fontFamily: 'Comforta', fontSize: 22),
                )),
            const SizedBox(height: 30),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.withOpacity(0.6),
                    minimumSize: const Size(140, 60),
                    shape: const StadiumBorder()),
                onPressed: () => Raz(),
                child: const Text(
                  "Remise à zéro",
                  style: TextStyle(fontFamily: 'Comforta', fontSize: 22),
                ))
          ],
        ),
      ),
    ));
  }
}
