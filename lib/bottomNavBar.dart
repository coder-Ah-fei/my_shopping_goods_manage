import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:my_shopping_goods_manage/pages/homePage.dart';
import 'package:my_shopping_goods_manage/pages/goodsClassPage.dart';
import 'package:my_shopping_goods_manage/pages/shoppingOrderListPage.dart';
import 'package:my_shopping_goods_manage/pages/shoppingCartPage.dart';
import 'package:my_shopping_goods_manage/pages/minePage.dart';
import 'package:my_shopping_goods_manage/pages/liquidSwipeDemo.dart';
import 'package:liquid_swipe/Constants/Helpers.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class BottomNavBar extends StatefulWidget{
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with SingleTickerProviderStateMixin {
  GlobalKey _bottomNavigationKey = GlobalKey();
  List _pages = [HomePage(), GoodsClassPage(), ShoppingOrderListPage(), ShoppingCartPage(), LiquidSwipeDemo()];
  /// 这里声明一个控制器，在flutter中好多用到控制器的地方，包括像最常见的表单
  TabController tabController;
  /// 这个就是比较核心的索引了，默认值就是我们的首页
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 5)
      ..addListener(() {
        /// setState 这里有点像咱们 的React，更改数据的时候是要在setState()里
        setState(() {
          currentIndex = tabController.index;
        });
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: currentIndex,
          height: 50.0,
          items: <Widget>[
            Icon(Icons.home, size: 25),
            Icon(Icons.format_list_bulleted, size: 25),
            Icon(Icons.library_books, size: 25),
            Icon(Icons.shopping_cart, size: 25),
            Icon(Icons.perm_identity, size: 25),
          ],
          color: Colors.white,
          buttonBackgroundColor: Colors.white,
          backgroundColor: Color(0xff4caf50),
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 300),
          /// 点击不同的底部导航
          onTap: (index) {
            //Handle button tap
            setState(() {
              currentIndex = index;
            });
            tabController.animateTo(index,
                duration: Duration(milliseconds: 300), curve: Curves.ease);
          },
        ),
        body: IndexedStack(
          index: currentIndex,
//          controller: tabController,
          children: <Widget>[
            Container(
              child: _pages[0],
            ),
            Container(
              child: _pages[1],
            ),
            Container(
              child: _pages[2],
            ),
            Container(
              child: _pages[3],
            ),
            Container(
              child: _pages[4],
            ),
          ],
        ));
  }
}