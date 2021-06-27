import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:submission_1/common/styles.dart';
import 'package:submission_1/data/model/drinks.dart';
import 'package:submission_1/data/model/foods.dart';
import 'package:submission_1/data/model/restaurants.dart';
import 'package:submission_1/ui/widgets/Icon_box.dart';

class DetailPage extends StatefulWidget {
  static const routeName = 'detail_page';

  final Restaurants restaurants;

  const DetailPage({Key? key, required this.restaurants}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Icon favoriteIcon = Icon(Icons.favorite_border);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
              color: primaryColor,
              height: size.height,
              width: size.width,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Hero(
                        tag: widget.restaurants.id,
                        child: Image.network(widget.restaurants.pictureId),
                      ),
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: IconBox(
                                width: 45,
                                height: 45,
                                child: Icon(Icons.arrow_back),
                              ),
                            ),
                            IconBox(
                              width: 150,
                              height: 55,
                              child: Text(
                                widget.restaurants.name,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setDummyFavorite();
                              },
                              child: IconBox(
                                width: 45,
                                height: 45,
                                child: favoriteIcon,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Center(
                      child: Text(
                        widget.restaurants.description,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 125,
                    child: ListView.builder(
                        itemCount: widget.restaurants.menus.drinks.length,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _buildDrinksItems(
                              context, widget.restaurants.menus.drinks[index]);
                        }),
                  ),
                  Container(
                    height: 125,
                    child: ListView.builder(
                        itemCount: widget.restaurants.menus.foods.length,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return _buildFoodsItems(
                              context, widget.restaurants.menus.foods[index]);
                        }),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildDrinksItems(BuildContext context, Drinks drinks) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: Column(
        children: [
          Lottie.asset(
              'assets/drinks.json',
              repeat: true,
              reverse: true,
              animate: true,
              width: 125,
              height: 100,
          ),
          Text(drinks.name),
        ],
      ),
    );
  }

  Widget _buildFoodsItems(BuildContext context, Foods foods) {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: Column(
        children: [
          Lottie.asset(
            'assets/foods.json',
            repeat: true,
            reverse: true,
            animate: true,
            width: 125,
            height: 100,
          ),
          Text(foods.name),
        ],
      ),
    );
  }

  void setDummyFavorite() {
    setState(() {
      if (favoriteIcon.icon == Icons.favorite_border) {
        favoriteIcon = Icon(
          Icons.favorite,
          color: secondaryColor,
        );
        final snackBar = SnackBar(content: Text('Add to Dummy Favorite'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        favoriteIcon = Icon(Icons.favorite_border);
        final snackBar = SnackBar(content: Text('Delete from Dummy Favorite'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }
}
