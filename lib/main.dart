import 'package:AlboomPhotos/src/pages/start_page.dart';
import 'package:flutter/material.dart';

import 'package:AlboomPhotos/routes/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'Gotham',
          accentColor: Color(0xff00B4AA),
          backgroundColor: Color(0xff202020),
          textTheme: TextTheme(
            title: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//            body1: TextStyle(fontSize: 14.0),
          )),
      initialRoute: '/',
      routes: getApplicationRoutes(),
      onGenerateRoute: (RouteSettings settings) {
        //catchall - rota que não tem nomes definidos
        return MaterialPageRoute(builder: (BuildContext context) => StartPage());
      },
    );
  }
}
