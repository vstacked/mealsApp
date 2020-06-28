import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:meals_app/utils/textStyleCustom.dart';
import 'package:meals_app/views/page/about.dart';
import 'package:meals_app/views/page/home.dart';
import 'package:meals_app/views/widgets/buildCachedImage.dart';

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
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.orange[200]),
            child: Center(
              child: BuildCachedImage(
                fit: BoxFit.contain,
                imgUrl: 'https://themealdb.com/images/logo-small.png',
                isHome: false,
              ),
            ),
          ),
          buildListTileTheme(context, Home(), 'Home', home, AntDesign.home),
          buildListTileTheme(
              context, About(), 'About', about, AntDesign.infocirlce),
        ],
      ),
    );
  }

  ListTileTheme buildListTileTheme(BuildContext context, Widget goto,
      String title, bool selected, IconData icon) {
    TextStyleCustom textStyleCustom = TextStyleCustom();
    return ListTileTheme(
      selectedColor: Colors.orange[200],
      child: ListTile(
        selected: selected,
        leading: Icon(icon),
        title: Text(
          title,
          style: textStyleCustom.text.copyWith(fontWeight: FontWeight.w400),
        ),
        onTap: () => (selected == home)
            ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => goto),
                (Route<dynamic> route) => false)
            : Navigator.push(
                context, MaterialPageRoute(builder: (context) => goto)),
      ),
    );
  }
}
