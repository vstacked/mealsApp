import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meals_app/views/page/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meals App',
      theme: ThemeData().copyWith(
        primaryColor: Colors.white,
        accentColor: Colors.orange[200],
      ),
      home: Home(),
    );
  }
}
