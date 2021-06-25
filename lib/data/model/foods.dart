
class Foods {
  late String name;

  Foods({
      required this.name});

  Foods.fromJson(dynamic json) {
    name = json['name'];
  }
}