class Stock {
  String stockId;
  String productId;
  String productName;
  String unitId;
  String unitName;
  int qty;

  Stock(
      {this.productId,
      this.productName,
      this.qty,
      this.stockId,
      this.unitId,
      this.unitName});

  Map toMap(Stock stock) {
    var data = Map<String, dynamic>();

    data['stock_id'] = stock.stockId;
    data['product_id'] = stock.productId;
    data['product_name'] = stock.productName;
    data['unit_name'] = stock.unitName;
    data['unit_id'] = stock.unitId;
    data['quantity'] = stock.qty;

    return data;
  }

  Stock.fromMap(Map<String, dynamic> mapData) {
    this.productId = mapData['product_id'];
    this.stockId = mapData['stock_id'];
    this.productName = mapData['product_name'];
    this.unitId = mapData['unit_id'];
    this.unitName = mapData['unit_name'];
    this.qty = mapData['quantity'];
  }
}
