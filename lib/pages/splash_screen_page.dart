import 'dart:async';

import 'package:flutter/material.dart';


/// 闪屏页面
class SplashScreenPage extends StatefulWidget {
  SplashScreenPage({Key key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  /// 设计一个计时器，用来等计时器结束的时候，跳转
  jumpPage() {
    return Timer(Duration(milliseconds: 3000), () {
      Navigator.pushReplacementNamed(context, 'guidePages');
    });
  }

  @override
  void initState() {
    super.initState();

    jumpPage();
  }

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Container(
  //      child: Image.asset("images/splashPic.png"),
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/splashPic.png"),
            fit: BoxFit.cover,
          ),
          /*gradient: LinearGradient(
              colors: [
                // 线性渐变 有个渐变的过程
                Colors.amber,
                Colors.cyanAccent
              ],
              begin: FractionalOffset.topCenter, // 顶部居中
              end: FractionalOffset.bottomCenter
          )*/
      ), //

    );
  }
}