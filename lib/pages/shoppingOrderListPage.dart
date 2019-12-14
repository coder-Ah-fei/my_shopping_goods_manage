import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:my_shopping_goods_manage/pages/sqflite/shoppinpgoods_db_provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ShoppingOrderListPage extends StatefulWidget {
  @override
  _ShoppingOrderListPageState createState() => _ShoppingOrderListPageState();
}

class _ShoppingOrderListPageState extends State<ShoppingOrderListPage> {
  TextEditingController textEditingControllerBarcode;
  List<TableRow> _list = [TableRow(children: [Center(child: Text("条形码"),), Center(child: Text("名称"),), Center(child: Text("分类"),), Center(child: Text("价格"),)])];

  @override
  void initState(){
    super.initState();
    textEditingControllerBarcode = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);


    // TODO: implement build
    return Scaffold(
      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 18,
        marginBottom: 20,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.crop_landscape),
              backgroundColor: Colors.cyanAccent,
              label: '扫码',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: (){
                _scan(textEditingControllerBarcode);
              },
          ),
          SpeedDialChild(
            child: Icon(Icons.delete_forever),
            backgroundColor: Colors.red,
            label: '清空',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () {
              _clearTable();
            },
          ),
        ],
      ),
      body: NestedScrollView(
          headerSliverBuilder: _sliverBuilder,
          body: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: TextField(
                      controller: textEditingControllerBarcode,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '条形码',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.settings_overscan),
                    onPressed: (){
                      _scan(textEditingControllerBarcode);
                    },
                  ),
                ],
              ),
              Card(

              ),
              Table(
                columnWidths: const{
                  //列宽
                  0: FixedColumnWidth(120.0),
                  1: FixedColumnWidth(120.0),
                },
                //表格边框样式
                border: TableBorder.all(
                  color: Colors.green,
                  width: 2.0,
                  style: BorderStyle.solid,
                ),
                children: _list,
              )
            ],
          )
      ),
    );
  }

  Future _clearTable()async{
    setState(() {
      _list = [TableRow(children: [Center(child: Text("条形码"),), Center(child: Text("名称"),), Center(child: Text("分类"),), Center(child: Text("价格"),)])];
    });
  }

  Future _scan(TextEditingController controller) async {
    String _scanText = await scanner.scan();
    _search(_scanText);
    setState((){
      controller.text = _scanText;
    });
  }
  Future _search(String barcode) async{
    ShoppingGoodsDbProvider provider = new ShoppingGoodsDbProvider();
    List<Map> shoppingGoods = await provider.getPersonProviderByBarcode(barcode);
    List<TableRow> tableRowList = [];
    for(Map map in shoppingGoods){
      TableRow tableRow = TableRow(
          children: [
            Center(child: Text(map["barcode"].toString()),),
            Center(child: Text(map["name"].toString()),),
            Center(child: Text(map["className"].toString()),),
            Center(child: Text(map["price"].toString()),),
          ]
      );
      tableRowList.add(tableRow);
    }
    setState(() {
      _list.insertAll(1, tableRowList);
    });
  }

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        centerTitle: true,    //标题居中
        expandedHeight: 200.0,  //展开高度200
        floating: false,  //不随着滑动隐藏标题
        pinned: true,    //固定在顶部
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text('我是一个FlexibleSpaceBar'),
          background: Image.network(
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531798262708&di=53d278a8427f482c5b836fa0e057f4ea&imgtype=0&src=http%3A%2F%2Fh.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F342ac65c103853434cc02dda9f13b07eca80883a.jpg",
            fit: BoxFit.cover,
          ),
        ),
      )
    ];
  }
}