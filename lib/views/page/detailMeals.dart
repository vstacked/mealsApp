import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:meals_app/models/areaModel.dart';
import 'package:meals_app/services/url.dart';
import 'package:meals_app/utils/strings.dart';
import 'package:meals_app/utils/textStyleCustom.dart';
import 'package:meals_app/viewModels/detailMealViewModel.dart';
import 'package:meals_app/views/widgets/buildCachedImage.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailMeal extends StatefulWidget {
  final String id;
  final List<AreaMeal> areaMeal;
  DetailMeal({@required this.id, @required this.areaMeal});
  @override
  _DetailMealState createState() => _DetailMealState();
}

class _DetailMealState extends State<DetailMeal> {
  TextStyleCustom textStyleCustom = TextStyleCustom();
  UrlApi urlApi = UrlApi();
  StringCustom stringCustom = StringCustom();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DetailMealViewModel>.reactive(
      viewModelBuilder: () => DetailMealViewModel(),
      onModelReady: (model) => model.setId(widget.id),
      builder: (context, model, child) {
        var data = (!model.isLoad) ? model.mealsDetail[0] : null;
        List<String> ingredients = List();
        List<String> measure = List();
        String countryCode = 'unknown';
        List<String> country = widget.areaMeal?.map((f) {
          return f.strArea;
        })?.toList();

        if (data != null) {
          for (int i = 1; i <= 20; i++) {
            if (data['strIngredient$i'] != "" &&
                data['strIngredient$i'] != null) {
              ingredients.add(data['strIngredient$i']);
              measure.add(data['strMeasure$i']);
            }
          }

          int index = 0;
          for (int i = 0; i < country.length; i++) {
            if (country[i] == "${data['strArea']}") {
              countryCode = stringCustom.countryCode[index];
            }
            index++;
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
                          icon: Icon(Ionicons.md_arrow_round_back),
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
                        titlePadding: EdgeInsets.all(5),
                        title: Container(
                          decoration: BoxDecoration(
                            color: Colors.white54,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 200),
                            child: AutoSizeText(
                              (data != null) ? data['strMeal'].toString() : "",
                              style: textStyleCustom.title.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                fontSize: 18.0,
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.center,
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
                                      buildSubValue(
                                        "${data['strArea']}",
                                        true,
                                        countryCode,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      buildSubTitle("Category"),
                                      SizedBox(height: 5),
                                      buildSubValue(
                                        "${data['strCategory']}",
                                        false,
                                        "${data['strCategory']}",
                                      ),
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
                                  buildSubValue(
                                      "${data['strTags']}", false, null),
                                ],
                              ),
                              SizedBox(height: 20),
                              buildTitle("Ingredients"),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 65,
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
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            border: Border.all(
                                              color: Colors.grey[300],
                                              width: 1,
                                            ),
                                          ),
                                          child: ListTile(
                                            leading: SizedBox(
                                              height: 40,
                                              width: 40,
                                              child: BuildCachedImage(
                                                fit: BoxFit.contain,
                                                imgUrl:
                                                    urlApi.ingredientsImage +
                                                        ifAnySpace(
                                                          ingredients
                                                              .toList()[index]
                                                              .toString(),
                                                        ) +
                                                        ".png",
                                                isHome: false,
                                              ),
                                            ),
                                            title: AutoSizeText(
                                              ingredients
                                                  .toList()[index]
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style:
                                                  textStyleCustom.text.copyWith(
                                                color: Colors.black45,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                            ),
                                            subtitle: AutoSizeText(
                                              measure
                                                  .toList()[index]
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style:
                                                  textStyleCustom.text.copyWith(
                                                color: Colors.orange[200],
                                                fontWeight: FontWeight.w400,
                                              ),
                                              maxLines: 1,
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
                              SizedBox(height: 10),
                              Text(
                                data['strInstructions'],
                                style: textStyleCustom.text.copyWith(
                                  fontSize: 14,
                                  color: Colors.black45,
                                ),
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
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ));
      },
    );
  }

  Text buildTitle(String text) {
    return Text(
      text,
      style: textStyleCustom.text.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
    );
  }

  Widget buildSubValue(String text, bool isArea, String value) {
    return Row(
      children: <Widget>[
        (value != null)
            ? (value == 'unknown')
                ? Icon(AntDesign.question)
                : SizedBox(
                    height: 40,
                    width: 40,
                    child: BuildCachedImage(
                      fit: BoxFit.contain,
                      imgUrl:
                          ((isArea) ? urlApi.areaImage : urlApi.categoryImage) +
                              ifAnySpace(value) +
                              ".png",
                      isHome: false,
                    ),
                  )
            : Container(),
        SizedBox(width: 5),
        AutoSizeText(
          text,
          style: textStyleCustom.text.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          maxLines: 1,
        ),
      ],
    );
  }

  String ifAnySpace(String value) {
    return (value.contains(" ")) ? value.replaceAll(" ", "%20") : value;
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
