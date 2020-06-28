import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:meals_app/models/areaModel.dart';
import 'package:meals_app/models/categoriesModel.dart';
import 'package:meals_app/models/mealsModel.dart';
import 'package:meals_app/services/url.dart';
import 'package:meals_app/utils/strings.dart';
import 'package:meals_app/utils/textStyleCustom.dart';
import 'package:meals_app/viewModels/homeViewModel.dart';
import 'package:meals_app/views/page/detailMeals.dart';
import 'package:meals_app/views/widgets/buildCachedImage.dart';
import 'package:meals_app/views/widgets/buildDrawer.dart';
import 'package:stacked/stacked.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isClicked = false;
  TextEditingController searchController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextStyleCustom textStyleCustom = TextStyleCustom();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) => model.getDataFromApi,
      builder: (context, model, child) {
        List<AreaMeal> areaMeal = model.area ?? null;
        return Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          drawer: BuildDrawer(
            home: true,
            about: false,
          ),
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Ionicons.md_list,
                color: Colors.black,
              ),
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            ),
            title: (isClicked)
                ? buildSearch(model)
                : buildDropdown(model, areaMeal),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  (isClicked) ? MaterialIcons.close : MaterialIcons.search,
                  color: Colors.black,
                ),
                onPressed: () {
                  searchController.clear();
                  setState(() {
                    isClicked = !isClicked;
                  });
                },
              )
            ],
          ),
          body: model.isLoad
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : buildHome(model),
        );
      },
    );
  }

  TextFormField buildSearch(HomeViewModel model) {
    return TextFormField(
      controller: searchController,
      onFieldSubmitted: (value) {
        model.setSearchValue(value);
        model.setAreaValue(null);
        model.getDataFromApi;
      },
      textInputAction: TextInputAction.search,
      cursorColor: Colors.orange[300],
      style: textStyleCustom.text.copyWith(color: Colors.black),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Search..',
        hintStyle: textStyleCustom.text,
      ),
    );
  }

  DropdownButton<String> buildDropdown(
      HomeViewModel model, List<AreaMeal> areaMeal) {
    UrlApi urlApi = UrlApi();
    StringCustom stringCustom = StringCustom();
    int index = 0;

    return DropdownButton(
      icon: Icon(MaterialIcons.keyboard_arrow_down),
      underline: Container(),
      style: textStyleCustom.text.copyWith(color: Colors.black),
      elevation: 2,
      hint: Text("Select Area"),
      value: model.areaValue,
      items: areaMeal?.map((f) {
        index++;
        return DropdownMenuItem(
          child: Row(
            children: <Widget>[
              (stringCustom.countryCode[index - 1] == 'unknown')
                  ? Icon(AntDesign.question)
                  : SizedBox(
                      height: 30,
                      width: 30,
                      child: BuildCachedImage(
                        fit: BoxFit.contain,
                        imgUrl: urlApi.areaImage +
                            stringCustom.countryCode[index - 1] +
                            ".png",
                        isHome: false,
                      ),
                    ),
              SizedBox(width: 5),
              Text(f.strArea),
            ],
          ),
          value: f.strArea,
        );
      })?.toList(),
      onChanged: (value) {
        model.setAreaValue(value);
        model.setSearchValue(null);
        model.getDataFromApi;
      },
    );
  }

  Widget buildHome(HomeViewModel model) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "TheMealDB",
                  style: textStyleCustom.title
                      .copyWith(fontSize: 35, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Food that meets your needs",
                  style: textStyleCustom.title,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: model.categoriesLength,
            itemBuilder: (BuildContext context, int index) {
              Category category = model.categories[index];
              return Center(
                child: GestureDetector(
                  onTap: () {
                    model.setCategory(category.strCategory);
                    model.setAreaValue(null);
                    model.setSearchValue(null);
                    model.getDataFromApi;
                  },
                  child: (model.category == category.strCategory)
                      ? (model.areaValue == null && model.searchValue == null)
                          ? buildCategory(category, Colors.orange[200])
                          : buildCategory(category, Colors.grey[100])
                      : buildCategory(category, Colors.grey[100]),
                ),
              );
            },
          ),
        ),
        Expanded(
          flex: 5,
          child: (model.isLoadList)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : (!model.isError)
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, childAspectRatio: 3 / 4),
                      itemCount: model.mealsLength,
                      itemBuilder: (BuildContext context, int index) {
                        Meal meals = model.meals[index];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailMeal(
                                  id: meals.idMeal,
                                  areaMeal: model.area ?? null),
                            ),
                          ),
                          child: Card(
                            color: Colors.grey[100],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            margin: EdgeInsets.all(4).copyWith(
                                top: (index % 2 == 1) ? 30 : 4,
                                bottom: (index % 2 == 1) ? 4 : 30),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: BuildCachedImage(
                                    imgUrl: meals.strMealThumb,
                                    fit: BoxFit.fill,
                                    isHome: true,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Flexible(
                                  child: AutoSizeText(
                                    meals.strMeal,
                                    style: textStyleCustom.text
                                        .copyWith(fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "Not Found",
                        style: textStyleCustom.text.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 15),
                      ),
                    ),
        ),
      ],
    );
  }

  Widget buildCategory(Category category, Color color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: 130,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50,
                width: 50,
                child: BuildCachedImage(
                  imgUrl: category.strCategoryThumb,
                  fit: BoxFit.contain,
                  isHome: false,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Flexible(
                child: AutoSizeText(
                  category.strCategory,
                  style: textStyleCustom.text
                      .copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
