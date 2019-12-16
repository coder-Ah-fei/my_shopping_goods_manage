import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_shopping_goods_manage/pages/sqflite/shoppinpgoods_db_provider.dart';
import 'package:my_shopping_goods_manage/model/shoppinggoods_model.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
class GoodsClassPage extends StatefulWidget {
  @override
  _GoodsClassPageState createState() => _GoodsClassPageState();
}

class _GoodsClassPageState extends State<GoodsClassPage> {
  static const _channelOpenFileManager = const MethodChannel('samples.flutter.io/openFileManager');
  List<TableRow> _listTableData = [];

  @override
  void initState(){
    super.initState();
    _search();
  }
  localPath() async {
    try {
      var tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      var appDocDir = await getLibraryDirectory();
      String appDocPath = appDocDir.path;

      print('临时目录: ' + tempPath);
      print('文档目录: ' + appDocPath);
    }
    catch(err) {
      print(err);
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Text("导出"),
            onPressed: (){
              _importDataFun();
            }
        ),
        body: NestedScrollView(
          headerSliverBuilder: _sliverBuilder,
          body: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              color: Colors.white,
              child: RefreshIndicator(
                child: ListView(
                  children: <Widget>[
                    Table(
                      columnWidths: const{
                        //列宽
                        0: FixedColumnWidth(50.0),
                        1: FixedColumnWidth(120.0),
                        2: FixedColumnWidth(120.0),
                      },
                      //表格边框样式
                      border: TableBorder.all(
                        color: Colors.green,
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),
                      children: _listTableData,
                    ),
                  ],
                ),
                onRefresh: _search
              )
            ),
          )
        ),
      ),
    );
  }

  void _importDataFun() async {
    ShoppingGoodsDbProvider provider = new ShoppingGoodsDbProvider();
    List<Map> shoppingGoods = await provider.getPersonProvider(await provider.getDataBase());
    print("flutter importData");
    String args1 = "";
    for(Map map in shoppingGoods){
      args1 += map["barcode"].toString() + "\t";
      args1 += map["name"].toString() + "\t";
      args1 += map["className"].toString() + "\t";
      args1 += map["price"].toString() + "\t";
      args1 += "\r\n";
    }

    Map<String, Object> params = {"args1": args1};
    final int result = await _channelOpenFileManager.invokeMethod('importData', params);
    if(result == 0){
      Fluttertoast.showToast(
          msg: "导出成功文件路径为【/sdcard/xicunshudianApp/】",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
    print(result);

  }

  Future _search() async{
    ShoppingGoodsDbProvider provider = new ShoppingGoodsDbProvider();
    List<Map> shoppingGoods = await provider.getPersonProvider(await provider.getDataBase());
    List<TableRow> tableRowList = [];
    for(Map map in shoppingGoods){
      TableRow tableRow = TableRow(

        children: [
          Center(child: Text(map["id"].toString()),),
          Center(child: Text(map["barcode"].toString()),),
          Center(child: Text(map["name"].toString()),),
          Center(child: Text(map["className"].toString()),),
          Center(child: Text(map["price"].toString()),),
        ]
      );
      tableRowList.add(tableRow);
    }
    print(tableRowList.length);
    setState(() {
      _listTableData = tableRowList;
    });
  }

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        leading: Text(""),
        centerTitle: true,    //标题居中
        expandedHeight: 200.0,  //展开高度200
        floating: false,  //不随着滑动隐藏标题
        pinned: true,    //固定在顶部
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text('商品列表'),
          background: Image.asset(
            "images/splashPic.png",
            fit: BoxFit.cover,
          ),
        ),
      )
    ];
  }


}