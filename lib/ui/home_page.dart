import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:submission_1/common/styles.dart';
import 'package:submission_1/data/model/restaurant.dart';
import 'package:submission_1/data/model/restaurants.dart';
import 'package:submission_1/ui/detail_page.dart';

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
  bool notFoundSearch = false;

  @override
  void initState() {
    getListRestaurant();
    super.initState();

    controller.addListener(() {
      double value = controller.offset / 139;

      setState(() {
        topContainer = value;
      });
    });
    filter.addListener(() {
      if (filter.text.isEmpty) {
        setState(() {
          searchText = "";
        });
      } else {
        setState(() {
          searchText = filter.text;
        });
      }
      checkFilter();
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
          cursorColor: secondaryColor,
          decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.search,
                color: secondaryColor,
              ),
              hintText: 'Search Restaurants'),
        );
      } else {
        searchIcon = Icon(Icons.search);
        appBarTitle =
            Text('Restaurants', style: TextStyle(color: Colors.black));
        restaurantFilteredList = restaurantList;
        notFoundSearch = false;
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
      if (filterList.isEmpty) {
        notFoundSearch = true;
      } else {
        restaurantFilteredList = filterList;
        notFoundSearch = false;
      }
    } else {
      restaurantFilteredList = restaurantList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: 75,
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
          backgroundColor: primaryColor,
          title: Center(
            child: appBarTitle,
          ),
        ),
        body: (notFoundSearch)
            ? _buildErrorWidget()
            : ListView.builder(
                physics: BouncingScrollPhysics(),
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

  Widget _buildErrorWidget() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              size: 75,
              color: secondaryColor,
            ),
            Text(
              'No Restaurant Found',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantsItem(BuildContext context, Restaurants restaurants) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, DetailPage.routeName,
            arguments: restaurants);
      },
      child: Container(
        height: 150,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.green.withAlpha(200), blurRadius: 7)
          ],
        ),
        child: Container(
          margin: EdgeInsets.only(top: 15, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Hero(
                tag: restaurants.id,
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: NetworkImage(
                    restaurants.pictureId,
                  ),
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
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.green[300],
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    restaurants.city,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    filter.dispose();
  }
}
