import 'package:flutter/material.dart';

import "./pages/gallery.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          fontFamily: 'Gotham',
          primarySwatch: Colors.blue,
          backgroundColor: Colors.black87,
          textTheme: TextTheme(
            title: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//            body1: TextStyle(fontSize: 14.0),
          )),
      home: GalleryPage(),
    );
  }
}
