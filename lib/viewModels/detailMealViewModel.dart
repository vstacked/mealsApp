import 'dart:convert';

import 'package:meals_app/models/mealsModelDetail.dart';
import 'package:meals_app/services/url.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

class DetailMealViewModel extends BaseViewModel {
  UrlApi urlApi = UrlApi();
  MealsModelDetail _mealsModelDetail;

  bool _isLoad = true;
  bool get isLoad => _isLoad;

  String id;

  Future getDataById() async {
    var response = await http.get(urlApi.byId + this.id);
    if (response.statusCode != 404 && response.contentLength != 2) {
      _mealsModelDetail = MealsModelDetail.fromJson(jsonDecode(response.body));
      if (_mealsModelDetail != null) _isLoad = false;
    }
    notifyListeners();
  }

  void setId(val) {
    id = val;
    if (id != null) getDataById();
    notifyListeners();
  }

  get mealsDetail => _mealsModelDetail?.meals ?? null;
  get mealsDetailLength => _mealsModelDetail?.meals?.length ?? 0;
}
