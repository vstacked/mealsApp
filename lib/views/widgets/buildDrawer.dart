import 'package:flutter/material.dart';
import 'package:meals_app/views/page/about.dart';
import 'package:meals_app/views/page/home.dart';

class BuildDrawer extends StatelessWidget {
  const BuildDrawer({Key key, @required this.home, @required this.about})
      : super(key: key);

  final bool home;
  final bool about;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(child: Text("data")),
          ListTile(
            selected: home,
            title: Text("Home"),
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                (Route<dynamic> route) => false),
          ),
          ListTile(
            selected: about,
            title: Text("About"),
            onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => About()),
                (Route<dynamic> route) => false),
          ),
        ],
      ),
    );
  }
}
