import 'dart:convert';
import 'restaurants.dart';

class Restaurant {
  late List<Restaurants> restaurants;

  Restaurant({required this.restaurants});

  Restaurant.fromJson(dynamic json) {
    restaurants = [];
    if (json != null) {
      final parsed = jsonDecode(json);
      parsed["restaurants"].forEach((resto) {
        restaurants.add(Restaurants.fromJson(resto));
      });
    }
  }
}
