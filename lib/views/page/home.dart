import 'package:flutter/material.dart';
import 'package:meals_app/models/areaModel.dart';
import 'package:meals_app/models/categoriesModel.dart';
import 'package:meals_app/models/mealsModel.dart';
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
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (model) => model.getDataFromApi,
      builder: (context, model, child) {
        List<AreaMeal> areaMeal = model.area ?? null;
        return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          drawer: BuildDrawer(
            home: true,
            about: false,
          ),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            ),
            title: (isClicked)
                ? buildSearch(model)
                : buildDropdown(model, areaMeal),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon((isClicked) ? Icons.close : Icons.search),
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
    );
  }

  DropdownButton<String> buildDropdown(
      HomeViewModel model, List<AreaMeal> areaMeal) {
    return DropdownButton(
      hint: Text("Select Area"),
      value: model.areaValue,
      items: areaMeal?.map((f) {
        return DropdownMenuItem(
          child: Text(f.strArea),
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
          padding: const EdgeInsets.all(8.0),
          child: Text("Meals App"),
        ),
        Expanded(
          flex: 1,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: model.categoriesLength,
            itemBuilder: (BuildContext context, int index) {
              Category category = model.categories[index];
              return Center(
                child: InkWell(
                  onTap: () {
                    model.setCategory(category.strCategory);
                    model.setAreaValue(null);
                    model.setSearchValue(null);
                    model.getDataFromApi;
                  },
                  child: (model.category == category.strCategory)
                      ? (model.areaValue == null && model.searchValue == null)
                          ? buildCategory(category, Colors.orange)
                          : buildCategory(category, Colors.grey)
                      : buildCategory(category, Colors.grey),
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
                              builder: (context) =>
                                  DetailMeal(id: meals.idMeal),
                            ),
                          ),
                          child: Card(
                            color: Colors.white,
                            margin: EdgeInsets.all(4).copyWith(
                                top: (index % 2 == 1) ? 30 : 4,
                                bottom: (index % 2 == 1) ? 4 : 30),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: BuildCachedImage(
                                    imgUrl: meals.strMealThumb,
                                  ),
                                ),
                                Text(meals.strMeal)
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Text("data Tidak Ada"),
        ),
      ],
    );
  }

  Container buildCategory(Category category, Color color) {
    return Container(
      height: 50,
      width: 100,
      color: color,
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 50,
            width: 50,
            child: BuildCachedImage(imgUrl: category.strCategoryThumb),
          ),
          Text(category.strCategory),
        ],
      ),
    );
  }
}
