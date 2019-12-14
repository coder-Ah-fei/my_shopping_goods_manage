
import 'package:my_shopping_goods_manage/model/shoppinggoods_model.dart';
import 'package:sqflite/sqlite_api.dart';

import 'package:my_shopping_goods_manage/pages/sqflite/base_db_provider.dart';


class ShoppingGoodsDbProvider extends BaseDbProvider{
  ///表名
  final String name = 'ShoppingGoods';
  final String columnId="id";
  final String columnBarcode = 'barcode';
  final String columnName = 'name';
  final String columnClassName = 'className';
  final String columnPrice = 'price';


  ShoppingGoodsDbProvider();

  @override
  tableName() {
    return name;
  }

  @override
  createTableString() {
    return '''
        create table $name (
        $columnId integer primary key,
        $columnBarcode text not null,
        $columnName text not null,
        $columnClassName text not null,
        $columnPrice text not null
        )
      ''';
  }

  ///查询数据库
  Future _getPersonProvider(Database db, int id) async {
    List<Map<String, dynamic>> maps =
    await db.rawQuery("select * from $name where $columnId = $id");
    return maps;
  }

  Future getPersonProvider(Database db) async {
    List<Map<String, dynamic>> maps =
    await db.rawQuery("select * from $name");
    return maps;
  }

  Future getPersonProviderByBarcode(String barcode) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps =
    await db.rawQuery("select * from $name where $columnBarcode = $barcode");
    return maps;
  }

  ///插入到数据库
  Future insert(ShoppingGoods model) async {
    Database db = await getDataBase();
    var userProvider = await _getPersonProvider(db, model.id);
    if (userProvider != null) {
      ///删除数据
      await db.delete(name, where: "$columnId = ?", whereArgs: [model.id]);
    }
    return await db.rawInsert("insert into $name ($columnId, $columnBarcode, $columnName, $columnClassName, $columnPrice) values (?,?,?,?,?)",[model.id, model.barcode, model.name, model.className, model.price]);
  }

  ///更新数据库
  Future<void> update(ShoppingGoods model) async {
    Database database = await getDataBase();
    await database.rawUpdate(
        "update $name set $columnBarcode = ?,$columnName = ?,$columnClassName = ?,$columnPrice = ? where $columnId= ?",[model.barcode, model.name, model.className, model.price, model.id]);

  }


  ///获取事件数据
  Future<ShoppingGoods> getPersonInfo(int id) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps  = await _getPersonProvider(db, id);
    if (maps.length > 0) {
      return ShoppingGoods.fromMap(maps[0]);
    }
    return null;
  }
}