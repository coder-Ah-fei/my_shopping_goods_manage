import 'package:flutter/material.dart';
import 'package:my_shopping_goods_manage/pages/splash_screen_page.dart';
import 'package:my_shopping_goods_manage/pages/guidePages.dart';
import 'package:my_shopping_goods_manage/bottomNavBar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreenPage(),
      routes: {
        'guidePages': (context) {
//          return GuidePagesPage(); // 跳转到引导页面
          return BottomNavBar();
        }
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
