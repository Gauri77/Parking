import 'package:flutter/material.dart';
import 'signin.dart';
import 'homepage.dart';
//import 'map.dart';
import 'createprofile.dart';
import 'showparking.dart';

var myKey = 'AIzaSyBNfTAcLOBbXN2M-JNqXdfkeiMdjTEACBc';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: false,
      home: SignInPage(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: Colors.amberAccent),
        primarySwatch: Colors.amber
      ),
      routes: <String, WidgetBuilder>{
        '/homepage':(BuildContext context) => HomePage(),
        //'/map':(BuildContext context) => Maps(userlocation: HomePageState.userLocation),
        '/createprofile':(BuildContext context) => CreateUserProfile(),
        '/showparking' : (BuildContext context) => ShowParking(),
      },
    );
  }
}