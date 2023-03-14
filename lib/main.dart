import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'bottom_bar.dart';
import 'musicPlayer.dart';
import 'acceuil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shazam Vin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Introduction(),
        '/music': (context) => MusicApp(),

      },
    );



    /**
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Introduction(),
    );
        **/
  }
}



