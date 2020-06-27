// To parse this JSON data, do
//
//     final mealsModelDetail = mealsModelDetailFromJson(jsonString);

import 'dart:convert';

class MealsModelDetail {
  MealsModelDetail({
    this.meals,
  });

  List<Map<String, String>> meals;

  factory MealsModelDetail.fromRawJson(String str) =>
      MealsModelDetail.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MealsModelDetail.fromJson(Map<String, dynamic> json) =>
      MealsModelDetail(
        meals: json["meals"] == null
            ? null
            : List<Map<String, String>>.from(json["meals"].map((x) =>
                Map.from(x).map((k, v) =>
                    MapEntry<String, String>(k, v == null ? null : v)))),
      );

  Map<String, dynamic> toJson() => {
        "meals": meals == null
            ? null
            : List<dynamic>.from(meals.map((x) => Map.from(x).map(
                (k, v) => MapEntry<String, dynamic>(k, v == null ? null : v)))),
      };
}
