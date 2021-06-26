import 'package:flutter/material.dart';
import 'package:submission_1/data/model/restaurants.dart';
import 'package:submission_1/ui/detail_page.dart';
import 'package:submission_1/ui/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant',
      theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => HomePage(),
        DetailPage.routeName: (context) =>
            DetailPage(restaurants: ModalRoute
                .of(context)
                ?.settings
                .arguments as Restaurants,
            )
      },
    );
  }
}


