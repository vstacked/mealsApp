import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:meals_app/utils/textStyleCustom.dart';
import 'package:meals_app/viewModels/detailMealViewModel.dart';
import 'package:meals_app/views/widgets/buildCachedImage.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailMeal extends StatefulWidget {
  final String id;
  DetailMeal({@required this.id});
  @override
  _DetailMealState createState() => _DetailMealState();
}

class _DetailMealState extends State<DetailMeal> {
  TextStyleCustom textStyleCustom = TextStyleCustom();
  Random random = Random();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DetailMealViewModel>.reactive(
      viewModelBuilder: () => DetailMealViewModel(),
      onModelReady: (model) => model.setId(widget.id),
      builder: (context, model, child) {
        var data = (!model.isLoad) ? model.mealsDetail[0] : null;
        List<String> ingredients = List();
        List<String> measure = List();

        if (data != null) {
          for (int i = 1; i <= 20; i++) {
            if (data['strIngredient$i'] != "" &&
                data['strIngredient$i'] != null) {
              ingredients.add(data['strIngredient$i']);
              measure.add(data['strMeasure$i']);
            }
          }
        }

        return Scaffold(
            backgroundColor: Colors.white,
            body: DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      elevation: 0,
                      leading: Container(
                        decoration: BoxDecoration(
                          color: Colors.white54,
                        ),
                        child: IconButton(
                          icon: Icon(FontAwesome.arrow_left),
                          color: Colors.black87,
                          iconSize: 25.0,
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      expandedHeight: 200,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Container(
                          decoration: BoxDecoration(
                            color: Colors.white54,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 250,
                            ),
                            child: Text(
                              (data != null) ? data['strMeal'].toString() : "",
                              style: textStyleCustom.title.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                fontSize: 18.0,
                              ),
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        background: BuildCachedImage(
                          imgUrl: (data != null) ? data['strMealThumb'] : "",
                          fit: BoxFit.cover,
                          isHome: false,
                        ),
                      ),
                    ),
                  ];
                },
                body: (data != null)
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      buildSubTitle("Area"),
                                      SizedBox(height: 5),
                                      buildSubValue("${data['strArea']}"),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      buildSubTitle("Category"),
                                      SizedBox(height: 5),
                                      buildSubValue("${data['strCategory']}"),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  buildSubTitle("Tags"),
                                  SizedBox(height: 5),
                                  buildSubValue("${data['strTags']}"),
                                ],
                              ),
                              SizedBox(height: 20),
                              buildTitle("Ingredients"),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 75,
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: ingredients.toList().length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Container(
                                          height: 75,
                                          width: 130,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Color.fromRGBO(
                                                  255,
                                                  165 +
                                                      random.nextInt(255 - 165),
                                                  0,
                                                  1)),
                                          child: ListTile(
                                            title: Text(
                                              ingredients
                                                  .toList()[index]
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: textStyleCustom.text
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      shadows: [
                                                    Shadow(
                                                      offset: Offset(0.2, 0.2),
                                                      blurRadius: 2,
                                                      color: Colors.black,
                                                    )
                                                  ]),
                                            ),
                                            subtitle: Text(
                                              measure
                                                  .toList()[index]
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: textStyleCustom.text
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      shadows: [
                                                    Shadow(
                                                      offset: Offset(0.2, 0.2),
                                                      blurRadius: 2,
                                                      color: Colors.black,
                                                    )
                                                  ]),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              buildTitle("Instructions"),
                              SizedBox(height: 5),
                              Text(
                                data['strInstructions'],
                                style: textStyleCustom.text,
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(height: 20),
                              buildTitle("More on Youtube"),
                              SizedBox(height: 5),
                              GestureDetector(
                                onTap: () => _launchURL(data['strYoutube']),
                                child: Text(
                                  "${data['strYoutube']}",
                                  style: textStyleCustom.text.copyWith(
                                    color: Colors.orange[200],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Container(),
              ),
            ));
      },
    );
  }

  Text buildTitle(String text) {
    return Text(
      text,
      style: textStyleCustom.text.copyWith(
        fontWeight: FontWeight.w800,
        fontSize: 18,
      ),
    );
  }

  Text buildSubValue(String text) {
    return Text(
      text,
      style: textStyleCustom.text.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }

  Text buildSubTitle(String text) {
    return Text(
      text,
      style: textStyleCustom.text.copyWith(fontWeight: FontWeight.w300),
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
