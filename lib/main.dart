import 'package:flutter/material.dart';

import 'package:movie_app/src/pages/home_page.dart';
import 'package:movie_app/src/pages/movie_detail.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build( BuildContext context ) {
    return MaterialApp(
      title: 'MovieApp',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/' : ( BuildContext context ) => HomePage(),
        'detail' : ( BuildContext context ) => MovieDetail( null ),
      },
    );
  }
}
