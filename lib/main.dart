import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp/Login.dart';
import 'package:whatsapp/RouteGeneration.dart';
import 'Home.dart';
import 'package:js/js.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  /*FirebaseFirestore db = FirebaseFirestore.instance;
  db.collection("usuarios")
  .doc("001")
  .set({"nome": "Claudineia"});*/

  runApp(MaterialApp(
    home: Login(),
    theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xff075E54)),//Color(0xff795548),
       //scaffoldBackgroundColor: Color(0xff25D366)
    ),
    initialRoute: "/",
    onGenerateRoute: RouteGeneration.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}



