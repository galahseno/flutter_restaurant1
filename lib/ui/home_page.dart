import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:submission_1/data/model/restaurant.dart';
import 'package:submission_1/data/model/restaurants.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController controller = ScrollController();
  TextEditingController filter = TextEditingController();
  String searchText = "";
  double topContainer = 0;
  List<Restaurants> restaurantList = [];
  List<Restaurants> restaurantFilteredList = [];
  Icon searchIcon = Icon(Icons.search);
  Widget appBarTitle =
      Text('Restaurants', style: TextStyle(color: Colors.black));

  _HomePageState() {
    filter.addListener(() {
      if (filter.text.isEmpty) {
        setState(() {
          searchText = "";
          restaurantFilteredList = restaurantList;
        });
      } else {
        setState(() {
          searchText = filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getListRestaurant();

    controller.addListener(() {
      double value = controller.offset / 139;

      setState(() {
        topContainer = value;
      });
    });
  }

  void getListRestaurant() async {
    final jsonFile = await rootBundle.loadString('assets/restaurant.json');
    setState(() {
      restaurantList = Restaurant.fromJson(jsonFile).restaurants;
      restaurantList.shuffle();
      restaurantFilteredList = restaurantList;
    });
  }

  void searchPress() {
    setState(() {
      if (searchIcon.icon == Icons.search) {
        searchIcon = Icon(Icons.close);
        appBarTitle = TextField(
          controller: filter,
          cursorColor: Colors.green[300],
          decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.green[300],
              ),
              hintText: 'Search Restaurants'),
        );
      } else {
        searchIcon = Icon(Icons.search);
        appBarTitle =
            Text('Restaurants', style: TextStyle(color: Colors.black));
        restaurantFilteredList = restaurantList;
        filter.clear();
      }
    });
  }

  void checkFilter() {
    if (searchText.isNotEmpty) {
      List<Restaurants> filterList = [];
      restaurantFilteredList.forEach((resto) {
        if (resto.name.toLowerCase().contains(searchText.toLowerCase())) {
          filterList.add(resto);
        }
      });
      restaurantFilteredList = filterList;
    }
  }

  @override
  Widget build(BuildContext context) {
    checkFilter();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 75,
          elevation: 0,
          leading: Icon(
            Icons.restaurant,
            color: Colors.black,
            size: 30,
          ),
          actions: [
            IconButton(
              icon: searchIcon,
              color: Colors.black,
              iconSize: 30,
              onPressed: searchPress,
            ),
          ],
          backgroundColor: Colors.white,
          title: Center(
            child: appBarTitle,
          ),
        ),
        body: ListView.builder(
          controller: controller,
          itemCount: restaurantFilteredList.length,
          itemBuilder: (context, index) {
            double scale = 1.0;
            if (topContainer > 0.5) {
              scale = index + 0.8 - topContainer;
              if (scale < 0) {
                scale = 0;
              } else if (scale > 1) {
                scale = 1;
              }
            }
            return Opacity(
              opacity: scale,
              child: Transform(
                alignment: Alignment.bottomCenter,
                transform: Matrix4.identity()..scale(scale, scale),
                child: Align(
                    heightFactor: 0.8,
                    alignment: Alignment.topCenter,
                    child: _buildRestaurantsItem(
                        context, restaurantFilteredList[index])),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRestaurantsItem(BuildContext context, Restaurants restaurants) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 150,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Colors.green.withAlpha(200), blurRadius: 7)
            ]),
        child: Container(
          margin: EdgeInsets.only(top: 15, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 100,
                backgroundImage: NetworkImage(
                  restaurants.pictureId,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    restaurants.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.star,
                          color: Colors.green[300],
                        ),
                      ),
                      Text(
                        restaurants.rating.toString(),
                        style:
                            TextStyle(fontSize: 15, color: Colors.green[300]),
                      ),
                    ],
                  ),
                  Text(
                    restaurants.city,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
