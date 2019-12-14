import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:my_shopping_goods_manage/bottomNavBar.dart';

/// 引导页面
class GuidePagesPage extends StatefulWidget {
  @override
  _GuidePagesPageState createState() => _GuidePagesPageState();
}

class _GuidePagesPageState extends State<GuidePagesPage> {
  final pages = [
    PageViewModel(
        pageColor: const Color(0xFF03A9F4),
        // iconImageAssetPath: 'assets/air-hostess.png',
        // bubble: Image.asset('images/guidePic1.png'),
        body: Text(
          '第一个页面的描述',
        ),
        title: Text(
          '第一个',
        ),
        titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
        bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
        mainImage: Image.asset(
          'images/guidePic1.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        )),
    PageViewModel(
      pageColor: const Color(0xFF8BC34A),
      // iconImageAssetPath: 'images/guidePic2.png',
      body: Text(
        '第二个页面的描述',
      ),
      title: Text('第二个'),
      mainImage: Image.asset(
        'images/guidePic2.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
    PageViewModel(
      pageColor: const Color(0xFF607D8B),
      // iconImageAssetPath: 'images/guidePic3.png',
      body: Text(
        '第三个页面的描述',
      ),
      title: Text('第三个'),
      mainImage: Image.asset(
        'images/guidePic3.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      titleTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
      bodyTextStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
  ];


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Builder(
      builder: (context) => IntroViewsFlutter(
        pages,
        backText: const Text("返回"),
        doneText: const Text("进入"),
        nextText: const Text("下一个"),
        skipText: const Text("跳过"),
        // showNextButton: true,
        // showBackButton: true,
        onTapDoneButton: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBar(),
            ), //MaterialPageRoute
          );
        },
        pageButtonTextStyles: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
        ),
      ), //IntroViewsFlutter
    );
  }

}