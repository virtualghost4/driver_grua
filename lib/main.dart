import 'package:flutter/material.dart';
import 'login_page.dart';
import 'maps_demo.dart';
import 'package:driver_grua/services_page.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Driver Grua',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      initialRoute: '/',
      routes: {
      '/': (context) => LoginPage(),
      '/second': (context) => PlaceMarkerPage(),
      '/third': (context) => ServicePage(),
      },
    );
  }
}