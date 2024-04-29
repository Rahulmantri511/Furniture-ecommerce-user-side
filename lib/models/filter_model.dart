// To parse this JSON data, do
//
//     final filterModel = filterModelFromJson(jsonString);

import 'dart:convert';

FilterModel filterModelFromJson(String str) => FilterModel.fromJson(json.decode(str));

String filterModelToJson(FilterModel data) => json.encode(data.toJson());

class FilterModel {
  List<Category> categories;

  FilterModel({
    required this.categories,
  });

  factory FilterModel.fromJson(Map<String, dynamic> json) => FilterModel(
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
  };
}

class Category {
  int id;
  String name;
  List<Filter> filters;

  Category({
    required this.id,
    required this.name,
    required this.filters,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    name: json["name"],
    filters: List<Filter>.from(json["filters"].map((x) => filterValues.map[x])),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "filters": List<dynamic>.from(filters.map((x) => filterValues.reverse[x])),
  };
}

enum Filter {
  P_COLORS,
  P_MATERIAL,
  P_PRICE
}

final filterValues = EnumValues({
  "p_colors": Filter.P_COLORS,
  "p_material": Filter.P_MATERIAL,
  "p_price": Filter.P_PRICE
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
