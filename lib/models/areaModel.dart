// To parse this JSON data, do
//
//     final areaModel = areaModelFromJson(jsonString);

import 'dart:convert';

class AreaModel {
  AreaModel({
    this.meals,
  });

  List<AreaMeal> meals;

  factory AreaModel.fromRawJson(String str) =>
      AreaModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AreaModel.fromJson(Map<String, dynamic> json) => AreaModel(
        meals: json["meals"] == null
            ? null
            : List<AreaMeal>.from(
                json["meals"].map((x) => AreaMeal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meals": meals == null
            ? null
            : List<dynamic>.from(meals.map((x) => x.toJson())),
      };
}

class AreaMeal {
  AreaMeal({
    this.strArea,
  });

  String strArea;

  factory AreaMeal.fromRawJson(String str) =>
      AreaMeal.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AreaMeal.fromJson(Map<String, dynamic> json) => AreaMeal(
        strArea: json["strArea"] == null ? null : json["strArea"],
      );

  Map<String, dynamic> toJson() => {
        "strArea": strArea == null ? null : strArea,
      };
}
