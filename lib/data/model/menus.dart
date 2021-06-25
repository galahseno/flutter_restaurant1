import 'foods.dart';
import 'drinks.dart';

class Menus {
  late List<Foods> foods;
  late List<Drinks> drinks;

  Menus({
      required this.foods,
      required this.drinks});

  Menus.fromJson(dynamic json) {
    if (json['foods'] != null) {
      foods = [];
      json['foods'].forEach((food) {
        foods.add(Foods.fromJson(food));
      });
    }
    if (json['drinks'] != null) {
      drinks = [];
      json['drinks'].forEach((drink) {
        drinks.add(Drinks.fromJson(drink));
      });
    }
  }
}