import 'package:flutter/material.dart';
import 'package:meals_app/viewModels/detailMealViewModel.dart';
import 'package:meals_app/views/widgets/buildCachedImage.dart';
import 'package:stacked/stacked.dart';

class DetailMeal extends StatefulWidget {
  final String id;
  DetailMeal({@required this.id});
  @override
  _DetailMealState createState() => _DetailMealState();
}

class _DetailMealState extends State<DetailMeal> {
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
            body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 200,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title:
                        Text((data != null) ? data['strMeal'].toString() : ""),
                    background: BuildCachedImage(
                        imgUrl: (data != null) ? data['strMealThumb'] : ""),
                  ),
                ),
              ];
            },
            body: (data != null)
                ? SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text("Area : \n${data['strArea']}"),
                            Text("Category : \n${data['strCategory']}"),
                            Flexible(
                                child: Text("Tags : \n${data['strTags']}")),
                          ],
                        ),
                        Text("Ingredients"),
                        Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: ingredients.toList().length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                height: 50,
                                width: 150,
                                child: ListTile(
                                  title: Text(
                                      ingredients.toList()[index].toString()),
                                  subtitle:
                                      Text(measure.toList()[index].toString()),
                                ),
                              );
                            },
                          ),
                        ),
                        Text("Instructions"),
                        Text(data['strInstructions']),
                        Text("More, On Youtube  "),
                        Text(
                          "Link Youtube : \n${data['strYoutube']}",
                        ),
                      ],
                    ),
                  )
                : Container(),
          ),
        ));
      },
    );
  }
}
