import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:meals_app/services/url.dart';
import 'package:meals_app/utils/textStyleCustom.dart';
import 'package:meals_app/views/widgets/buildDrawer.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  UrlApi urlApi = UrlApi();
  TextStyleCustom textStyleCustom = TextStyleCustom();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      drawer: BuildDrawer(
        about: true,
        home: false,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Ionicons.md_list,
            color: Colors.black87,
          ),
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        centerTitle: true,
        title: Text("About",
            style: textStyleCustom.text
                .copyWith(fontWeight: FontWeight.w600, color: Colors.black87)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  child: Image.asset(
                    'images/img.jpg',
                    height: 150,
                    width: 150,
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  buildTextTitle("Nama"),
                  Text(
                    "Muhammad Rizki Nurlahid",
                    style: textStyleCustom.text.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  )
                ],
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  buildTextTitle("Source Code"),
                  GestureDetector(
                    onTap: () => _launchURL(urlApi.sourceCode),
                    child: buildTextLink(urlApi.sourceCode),
                  )
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  buildTextTitle("Tujuan"),
                  Text(
                    "Untuk menambah wawasan tentang makanan-makanan dari berbagai kategori serta negara",
                    style: textStyleCustom.text,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  buildTextTitle("Tools"),
                  SizedBox(height: 15),
                  buildSubTitle("Despendencies :"),
                  GestureDetector(
                    onTap: () => _launchURL(urlApi.stacked),
                    child: buildTextLink("stacked"),
                  ),
                  GestureDetector(
                    onTap: () => _launchURL(urlApi.http),
                    child: buildTextLink("http"),
                  ),
                  GestureDetector(
                    onTap: () => _launchURL(urlApi.cachedNetworkImage),
                    child: buildTextLink("cached_network_image"),
                  ),
                  GestureDetector(
                    onTap: () => _launchURL(urlApi.flutterIcons),
                    child: buildTextLink("flutter_icons"),
                  ),
                  GestureDetector(
                    onTap: () => _launchURL(urlApi.urlLauncher),
                    child: buildTextLink("url_launcher"),
                  ),
                  SizedBox(height: 15),
                  buildSubTitle("Fonts :"),
                  GestureDetector(
                    onTap: () => _launchURL(urlApi.museoModerno),
                    child: buildTextLink("MuseoModerno"),
                  ),
                  GestureDetector(
                    onTap: () => _launchURL(urlApi.roboto),
                    child: buildTextLink("Roboto"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text buildSubTitle(String text) {
    return Text(
      text,
      style: textStyleCustom.text
          .copyWith(fontSize: 13, fontWeight: FontWeight.w500),
    );
  }

  Text buildTextLink(String text) {
    return Text(
      text,
      style: textStyleCustom.text.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Colors.orange[200],
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Text buildTextTitle(String title) {
    return Text(
      title,
      style: textStyleCustom.text.copyWith(
        fontSize: 15,
      ),
    );
  }

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
