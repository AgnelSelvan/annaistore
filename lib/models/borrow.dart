import 'package:annaistore/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Borrow {
  String borrowId;
  bool isRegularCustomer;
  User user;
  List productList;
  List priceList;
  List taxList;
  List qtyList;
  int totalPrice;

  Borrow(
      {this.taxList,
      this.productList,
      this.isRegularCustomer,
      this.priceList,
      this.totalPrice,
      this.user,
      this.qtyList,
      this.borrowId});

  Map toMap(Borrow borrow) {
    var data = Map<String, dynamic>();

    data['borrow_id'] = borrow.borrowId;
    data['is_regular_customer'] = borrow.isRegularCustomer;
    data['user'] = borrow.user.toMap(user);
    data['product_list'] = borrow.productList;
    data['price_list'] = borrow.priceList;
    data['tax_list'] = borrow.taxList;
    data['qty_list'] = borrow.qtyList;
    data['total_price'] = borrow.totalPrice;

    return data;
  }

  Borrow.fromMap(Map<String, dynamic> mapData) {
    this.borrowId = mapData['borrow_id'];
    this.isRegularCustomer = mapData['is_regular_customer'];
    this.user = mapData['user'];
    this.productList = mapData['product_list'];
    this.priceList = mapData['price_list'];
    this.taxList = mapData['tax_list'];
    this.totalPrice = mapData['total_price'];
    this.qtyList = mapData['qty_list'];
  }
}
