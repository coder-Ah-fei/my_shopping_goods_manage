
final String tableShoppingGoods = 'shoppingGoods';
final String columnBarcode = 'barcode';
final String columnName = 'name';
final String columnClassName = 'className';
final String columnPrice = 'price';

class ShoppingGoods {
  int id;
  String barcode;
  String name;
  String className;
  String price;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnBarcode: barcode,
      columnName: name,
      columnClassName: className,
      columnPrice: price,
    };
    return map;
  }

  ShoppingGoods();

  ShoppingGoods.fromMap(Map<String, dynamic> map) {
    barcode = map[columnBarcode];
    name = map[columnName];
    className = map[columnClassName];
    price = map[columnPrice];
  }
}