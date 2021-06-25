import 'dart:convert';

import 'menus.dart';

class Restaurants {
  late String id;
  late String name;
  late String description;
  late String pictureId;
  late String city;
  late dynamic rating;
  late Menus menus;

  Restaurants({
      required this.id,
      required this.name,
      required this.description,
      required this.pictureId,
      required this.city,
      required this.rating,
      required this.menus});

  Restaurants.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    pictureId = json['pictureId'];
    city = json['city'];
    rating = json['rating'];
    menus = Menus.fromJson(json['menus']);
  }
}
