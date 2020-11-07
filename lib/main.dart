import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_playera/firstscreen.dart';

import 'loginpage.dart';

bool iniroute = false;
String localname = '';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras[1];
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  if (sharedPreferences.getBool('loggedIn') != null) {
    iniroute = sharedPreferences.getBool('loggedIn');
    if (iniroute) {
      localname = sharedPreferences.getString('name');
    }
  }
  runApp(MyApp(firstCamera));
}

class MyApp extends StatelessWidget {
  final camera;
  MyApp(this.camera);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VideoPlayer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: iniroute ? FirstScreen(camera) : LoginPage(camera),
    );
  }
}
