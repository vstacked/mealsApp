// To parse this JSON data, do
//
//     final categoriesModel = categoriesModelFromJson(jsonString);

import 'dart:convert';

class CategoriesModel {
  CategoriesModel({
    this.categories,
  });

  List<Category> categories;

  factory CategoriesModel.fromRawJson(String str) =>
      CategoriesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
        categories: json["categories"] == null
            ? null
            : List<Category>.from(
                json["categories"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categories": categories == null
            ? null
            : List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}

class Category {
  Category({
    this.idCategory,
    this.strCategory,
    this.strCategoryThumb,
    this.strCategoryDescription,
  });

  String idCategory;
  String strCategory;
  String strCategoryThumb;
  String strCategoryDescription;

  factory Category.fromRawJson(String str) =>
      Category.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        idCategory: json["idCategory"] == null ? null : json["idCategory"],
        strCategory: json["strCategory"] == null ? null : json["strCategory"],
        strCategoryThumb:
            json["strCategoryThumb"] == null ? null : json["strCategoryThumb"],
        strCategoryDescription: json["strCategoryDescription"] == null
            ? null
            : json["strCategoryDescription"],
      );

  Map<String, dynamic> toJson() => {
        "idCategory": idCategory == null ? null : idCategory,
        "strCategory": strCategory == null ? null : strCategory,
        "strCategoryThumb": strCategoryThumb == null ? null : strCategoryThumb,
        "strCategoryDescription":
            strCategoryDescription == null ? null : strCategoryDescription,
      };
}
