class Product {
  String code;
  String name;
  String id;
  String hsnCode;
  String unit;
  int purchaseRate;
  int sellingRate;

  Product({this.name, this.code, this.purchaseRate, this.sellingRate, this.id, this.unit, this.hsnCode});

  Map toMap(Product product) {
    var data = Map<String, dynamic>();
    data['code'] = product.code;
    data['name'] = product.name;
    data['id'] = product.id;
    data['purchase_rate'] = product.purchaseRate;
    data['selling_rate'] = product.sellingRate;
    data['hsn_code'] = product.hsnCode;
    data['unit'] = product.unit;

    return data;
  }

  Product.fromMap(Map<String, dynamic> mapData) {
    this.code = mapData['code'];
    this.name = mapData['name'];
    this.id = mapData['id'];
    this.purchaseRate = mapData['purchase_rate'];
    this.sellingRate = mapData['selling_rate'];
    this.hsnCode = mapData['hsn_code'];
    this.unit = mapData['unit']; 
  }
}
