import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:my_shopping_goods_manage/pages/sqflite/shoppinpgoods_db_provider.dart';
import 'package:my_shopping_goods_manage/model/shoppinggoods_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _channelOpenFileManager = const MethodChannel('samples.flutter.io/openFileManager');
  static const EventChannel eventChannel = EventChannel("samples.flutter.io/textList");
  TextEditingController textEditingControllerBarcode;
  TextEditingController textEditingControllerName;
  TextEditingController textEditingControllerClassName;
  TextEditingController textEditingControllerPrice;
  List list;

  @override
  void initState(){
    super.initState();

    textEditingControllerBarcode = TextEditingController();
    textEditingControllerName = TextEditingController();
    textEditingControllerClassName = TextEditingController();
    textEditingControllerPrice = TextEditingController();

    eventChannel.receiveBroadcastStream().listen(_onEnvent, onError: _onError);

//    MethodChannel('samples.flutter.io/textList').setMethodCallHandler((handler){
//      switch (handler.method) {
//        case 'getTextList':
//          var msg = handler.arguments;
//          print(msg);
//          break;
//      }
//      return null;
//    });
  }
  void _onEnvent(Object obj) async {
    print(obj);
    String text = obj == null ? "" : obj.toString();
    List<String> list = text.split(",");
    int total = list.length;
    int successInsertNum = 0;
    int successUpdateNum = 0;
    for (var i = 1; i < list.length; i++) {
      List<String> lineData = list[i].split("\t");
      ShoppingGoodsDbProvider provider = new ShoppingGoodsDbProvider();
      List<Map> shoppingGoodsList = await provider.getPersonProviderByBarcode(lineData[0]);

      ShoppingGoods shoppingGoods= ShoppingGoods();
      shoppingGoods.barcode = lineData[0];
      shoppingGoods.name = lineData[1];
      shoppingGoods.className = lineData[2];
      shoppingGoods.price = lineData[3];

      if(shoppingGoodsList.length > 0){
        // 如果存在，则更新
        provider.update(shoppingGoods);
        successUpdateNum += 1;
      }else{
        // 否则插入
        provider.insert(shoppingGoods);
        successInsertNum += 1;
      }
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
            title: Text("提示"),
            content: Text("导入成功，一共$total条，其中更新$successUpdateNum条,新增$successInsertNum条"),
            actions: <Widget>[
              FlatButton(
                child: Text("关闭"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ]
        );
      }
    );

    setState(() {

    });
  }

  void _onError(Object obj){

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
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
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: TextField(
                      controller: textEditingControllerName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        labelText: '商品名称',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.settings_overscan),
                    onPressed: (){
                      _scan(textEditingControllerName);
                    },
                  ),
                ],
              ),

              TextField(
                controller: textEditingControllerClassName,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: '商品分类',
                ),
              ),
              TextField(
                controller: textEditingControllerPrice,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: '价格',
                ),
              ),
              OutlineButton(
                  child: Text("提交"),
                  onPressed: (){

                    ShoppingGoodsDbProvider provider = new ShoppingGoodsDbProvider();
                    ShoppingGoods shoppingGoods= ShoppingGoods();
                    shoppingGoods.barcode = textEditingControllerBarcode.text;
                    shoppingGoods.name = textEditingControllerName.text;
                    shoppingGoods.className = textEditingControllerClassName.text;
                    shoppingGoods.price = textEditingControllerPrice.text;

                    if(
                    shoppingGoods.barcode == "" ||
                        shoppingGoods.name == "" ||
                        shoppingGoods.className == "" ||
                        shoppingGoods.price == ""
                    ){
                      Fluttertoast.showToast(
                          msg: "保存失败，请补充信息",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      return;
                    }
                    provider.insert(shoppingGoods);
                    Fluttertoast.showToast(
                        msg: "保存成功",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                    textEditingControllerBarcode.text = '';
                    textEditingControllerName.text = '';
                    textEditingControllerClassName.text = '';
                    textEditingControllerPrice.text = '';
                  }
              ),
              OutlineButton(
                  child: Text("查询"),
                  onPressed: (){
                    _search();
                  }
              ),
              OutlineButton(
                  child: Text("数据导入"),
                  onPressed: (){
                    _loadTextData();
                  }
              ),
              Expanded(
                child: Text(
                  list.toString(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  Future _scan(TextEditingController controller) async {
    String _scanText = await scanner.scan();
    print("aaa");
    setState((){
      controller.text = _scanText;
    });
  }



  Future _createDb() async {


  }

  Future _search() async{
    ShoppingGoodsDbProvider provider = new ShoppingGoodsDbProvider();
    List<Map> shoppingGoods = await provider.getPersonProvider(await provider.getDataBase());
    setState(() {
      list = shoppingGoods;
    });
    print(list);
  }

  void _loadTextData() async {
    print("打开文件管理");
//    await _channelOpenFileManager.invokeMethod("getBatteryLevel");
    final int result = await _channelOpenFileManager.invokeMethod('openFileManager');
    print(result);

//    var tempDir = await getTemporaryDirectory();
//    String tempPath = tempDir.path;
//
//    var appDocDir = await getApplicationDocumentsDirectory();
//    String appDocPath = appDocDir.path;
//
//
//    print(tempPath);
//    print(appDocPath);
  }

}