import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowModel {
  String borrowId;
  List<dynamic> productList;
  List<dynamic> qtyList;
  List<dynamic> taxList;
  List<dynamic> sellingRateList;
  int price;
  int givenAmount;
  String billNo;
  String mobileNo;
  Timestamp timestamp;
  String customerName;

  BorrowModel(
      {this.billNo,
      this.borrowId,
      this.customerName,
      this.givenAmount,
      this.mobileNo,
      this.price,
      this.productList,
      this.timestamp,
      this.qtyList,
      this.sellingRateList,
      this.taxList});
  Map toMap(BorrowModel youGave) {
    var data = Map<String, dynamic>();
    data['bill_no'] = youGave.billNo;
    data['borrow_id'] = youGave.borrowId;
    data['customer_name'] = youGave.customerName;
    data['given_amount'] = youGave.givenAmount;
    data['mobile_no'] = youGave.mobileNo;
    data['price'] = youGave.price;
    data['timestamp'] = youGave.timestamp;
    data['product_list'] = youGave.productList;
    data['quantity_list'] = youGave.qtyList;
    data['selling_rate_list'] = youGave.sellingRateList;
    data['tax_list'] = youGave.taxList;
    return data;
  }

  BorrowModel.fromMap(Map<String, dynamic> mapData) {
    this.billNo = mapData['bill_no'];
    this.borrowId = mapData['borrow_id'];
    this.customerName = mapData['customer_name'];
    this.givenAmount = mapData['given_amount'];
    this.mobileNo = mapData['mobile_no'];
    this.price = mapData['price'];
    this.productList = mapData['product_list'];
    this.qtyList = mapData['quantity_list'];
    this.sellingRateList = mapData['selling_rate_list'];
    this.taxList = mapData['tax_list'];
    this.timestamp = mapData['timestamp'];
  }
}
