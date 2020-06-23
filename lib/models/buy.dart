import 'package:cloud_firestore/cloud_firestore.dart';

class Buys {
  String buyId;
  List<dynamic> productListId;
  List<dynamic> productList;
  List<dynamic> qtyList;
  List<dynamic> taxList;
  List<dynamic> sellingRateList;
  int price;
  String billNo;
  bool isTax;
  bool isPaid;
  Timestamp timestamp;

  Buys(
      {this.billNo,
      this.buyId,
      this.price,
      this.productList,
      this.timestamp,
      this.qtyList,
      this.sellingRateList,
      this.taxList,
      this.productListId,
      this.isTax,
      this.isPaid});

  Map toMap(Buys youGave) {
    var data = Map<String, dynamic>();
    data['bill_no'] = youGave.billNo;
    data['price'] = youGave.price;
    data['timestamp'] = youGave.timestamp;
    data['product_list'] = youGave.productList;
    data['quantity_list'] = youGave.qtyList;
    data['selling_rate_list'] = youGave.sellingRateList;
    data['tax_list'] = youGave.taxList;
    data['product_list_id'] = youGave.productListId;
    data['is_tax'] = youGave.isTax;
    data['is_paid'] = youGave.isPaid;
    data['buy_id'] = youGave.buyId;
    return data;
  }

  Buys.fromMap(Map<String, dynamic> mapData) {
    this.billNo = mapData['bill_no'];
    this.buyId = mapData['buy_id'];
    this.price = mapData['price'];
    this.productList = mapData['product_list'];
    this.qtyList = mapData['quantity_list'];
    this.sellingRateList = mapData['selling_rate_list'];
    this.taxList = mapData['tax_list'];
    this.timestamp = mapData['timestamp'];
    this.productListId = mapData['product_list_id'];
    this.isTax = mapData['is_tax'];
    this.isPaid = mapData['is_paid'];
  }
}
