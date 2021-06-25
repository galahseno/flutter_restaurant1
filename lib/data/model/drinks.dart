
class Drinks {
  late String name;

  Drinks({
      required this.name});

  Drinks.fromJson(dynamic json) {
    name = json['name'];
  }
}