// To parse this JSON data, do
//
//     final mealsModel = mealsModelFromJson(jsonString);

import 'dart:convert';

class MealsModel {
  MealsModel({
    this.meals,
  });

  List<Meal> meals;

  factory MealsModel.fromRawJson(String str) =>
      MealsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MealsModel.fromJson(Map<String, dynamic> json) => MealsModel(
        meals: json["meals"] == null
            ? null
            : List<Meal>.from(json["meals"].map((x) => Meal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meals": meals == null
            ? null
            : List<dynamic>.from(meals.map((x) => x.toJson())),
      };
}

class Meal {
  Meal({
    this.strMeal,
    this.strMealThumb,
    this.idMeal,
  });

  String strMeal;
  String strMealThumb;
  String idMeal;

  factory Meal.fromRawJson(String str) => Meal.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        strMeal: json["strMeal"] == null ? null : json["strMeal"],
        strMealThumb:
            json["strMealThumb"] == null ? null : json["strMealThumb"],
        idMeal: json["idMeal"] == null ? null : json["idMeal"],
      );

  Map<String, dynamic> toJson() => {
        "strMeal": strMeal == null ? null : strMeal,
        "strMealThumb": strMealThumb == null ? null : strMealThumb,
        "idMeal": idMeal == null ? null : idMeal,
      };
}
