import 'dart:convert';
import 'package:meals_app/models/areaModel.dart';
import 'package:meals_app/models/categoriesModel.dart';
import 'package:meals_app/models/mealsModel.dart';
import 'package:meals_app/services/url.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class HomeViewModel extends BaseViewModel {
  UrlApi urlApi = UrlApi();
  MealsModel _mealsModel;
  CategoriesModel _categoriesModel;
  AreaModel _areaModel;

  String category = "Beef";
  String areaValue;
  String searchValue;
  bool isError = false;

  String _nama;
  String _id;
  bool _isLoad = true;
  bool _isLoadList = false;
  String get nama => _nama;
  String get id => _id;
  bool get isLoad => _isLoad;
  bool get isLoadList => _isLoadList;

  Future _getDataFromApi() async {
    _getCategories();
    _getArea();

    var response = await http.get((this.searchValue != null)
        ? urlApi.searchByName + this.searchValue
        : (this.areaValue == null)
            ? urlApi.byCategory + this.category
            : urlApi.byArea + this.areaValue);

    if (response.statusCode != 404 && response.contentLength != 2) {
      _mealsModel = MealsModel.fromJson(jsonDecode(response.body));

      if (_mealsModel != null && _categoriesModel != null && _areaModel != null)
        _isLoad = _isLoadList = false;

      if (_mealsModel?.meals?.length == null)
        isError = true;
      else
        isError = false;
    }

    notifyListeners();
  }

  Future _getCategories() async {
    var response = await http.get(urlApi.categories);
    if (response.statusCode != 404 && response.contentLength != 2) {
      _categoriesModel = CategoriesModel.fromJson(jsonDecode(response.body));
      if (_mealsModel != null && _categoriesModel != null && _areaModel != null)
        _isLoad = _isLoadList = false;
    }
    notifyListeners();
  }

  Future _getArea() async {
    var response = await http.get(urlApi.area);
    if (response.statusCode != 404 && response.contentLength != 2) {
      _areaModel = AreaModel.fromJson(jsonDecode(response.body));
      if (_mealsModel != null && _categoriesModel != null && _areaModel != null)
        _isLoad = _isLoadList = false;
    }
    notifyListeners();
  }

  void setCategory(val) {
    category = val;
    _isLoadList = true;
    notifyListeners();
  }

  void setAreaValue(val) {
    areaValue = val;
    _isLoadList = true;
    notifyListeners();
  }

  void setSearchValue(val) {
    searchValue = val;
    _isLoadList = true;
    notifyListeners();
  }

  get getDataFromApi => _getDataFromApi();
  get meals => (!_isLoad) ? _mealsModel.meals : null;
  get mealsLength => (!_isLoad) ? _mealsModel?.meals?.length ?? 0 : 0;

  get categories => _categoriesModel.categories;
  get categoriesLength => _categoriesModel.categories.length;

  get area => (!_isLoad) ? _areaModel.meals : null;
}
