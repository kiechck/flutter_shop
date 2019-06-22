import 'package:flutter/material.dart';
import 'package:flutter_shop/pages/index_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Welcome to Flutter',
        theme: ThemeData(
          primaryColor: Colors.purple[400],
        ),
        home: IndexPage(),
      ),
    );
  }
}
