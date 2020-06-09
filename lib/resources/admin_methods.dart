import 'package:annaistore/constants/strings.dart';
import 'package:annaistore/models/category.dart';
import 'package:annaistore/models/product.dart';
import 'package:annaistore/models/sub-category.dart';
import 'package:annaistore/models/unit.dart';
import 'package:annaistore/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class AdminMethods {
  static final _firestore = Firestore.instance;

  CollectionReference _unitCollection = _firestore.collection(UNITS_STRING);
  CollectionReference _categoryCollection =
      _firestore.collection(CATEGORIES_STRING);
  CollectionReference _subCategoryCollection =
      _firestore.collection('sub_categories');
  CollectionReference _productCollection = _firestore.collection('product');
  CollectionReference _customerCollection = _firestore.collection('customer');

  Future<void> addSymbolToDb(String formalName, String symbol) async {
    Unit unit = Unit(formalName: formalName, unit: symbol, unitId: symbol);
    await _unitCollection.document(symbol).setData(unit.toMap(unit));
  }

  Future<bool> isUnitExists(String symbol) async {
    try {
      QuerySnapshot docs =
          await _unitCollection.where('unit', isEqualTo: symbol).getDocuments();
      List<DocumentSnapshot> doc = docs.documents;
      return doc.length == 0 ? false : true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<QuerySnapshot> fetchAllUnit() {
    return _unitCollection.snapshots();
  }

  Future<void> deleteUnit(String unit) async {
    await _unitCollection.document(unit).delete();
  }

  Future<void> addCategoryToDb(
      String hsnCode, String productName, int tax) async {
    String docId = _categoryCollection.document().documentID;
    Category category = Category(
      id: docId,
      hsnCode: hsnCode,
      productName: productName,
      tax: tax,
    );
    _categoryCollection.document(docId).setData(category.toMap(category));
  }

  Future<bool> isCategoryExists(String hsnCode) async {
    try {
      QuerySnapshot docs = await _categoryCollection
          .where('hsn_code', isEqualTo: hsnCode)
          .getDocuments();
      List<DocumentSnapshot> doc = docs.documents;
      return doc.length == 0 ? false : true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<QuerySnapshot> fetchAllCategory() {
    return _categoryCollection.snapshots();
  }

  Future<void> deleteCategory(String id) async {
    await _categoryCollection.document(id).delete();
  }

  Future<void> addSubCategoryToDb(String productName, String hsnCode) async {
    String docId = _subCategoryCollection.document().documentID;
    SubCategory subCategory =
        SubCategory(id: docId, productName: productName, hsnCode: hsnCode);
    _subCategoryCollection
        .document(docId)
        .setData(subCategory.toMap(subCategory));
  }

  Future<bool> isSubCategoryExists(String productName, String hsnCode) async {
    try {
      QuerySnapshot docs = await _subCategoryCollection
          .where('product_name', isEqualTo: productName)
          .where('hsn_code', isEqualTo: hsnCode)
          .getDocuments();
      List<DocumentSnapshot> doc = docs.documents;
      return doc.length == 0 ? false : true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<QuerySnapshot> fetchAllSubCategory() {
    return _subCategoryCollection.snapshots();
  }

  Future<void> deleteSubCategory(String id) async {
    await _subCategoryCollection.document(id).delete();
  }

  Future<void> addProductToDb(String code, String name, int purchaseRate,
      int sellingRate, String hsnCode, String unit) async {
    String docId = _productCollection.document().documentID;
    Product product = Product(
        id: docId,
        name: name,
        code: code,
        hsnCode: hsnCode,
        unit: unit,
        purchaseRate: purchaseRate,
        sellingRate: sellingRate);
    _productCollection.document(docId).setData(product.toMap(product));
  }

  Future<bool> isProductExists(String name) async {
    try {
      QuerySnapshot docs = await _productCollection
          .where('name', isEqualTo: name)
          .getDocuments();

      List<DocumentSnapshot> doc = docs.documents;

      return doc.length == 0 ? false : true;
    } catch (e) {
      return false;
    }
  }

  Stream<QuerySnapshot> fetchAllProduct() {
    return _productCollection.snapshots();
  }

  Future<void> addCustomerToDb(String name, String email, String address,
      String state, int pincode, int mobileNo, String gstin) async {
    String docId = _customerCollection.document().documentID;
    User user = User(
        uid: docId,
        name: name,
        email: email,
        address: address,
        state: state,
        pincode: pincode,
        mobileNo: mobileNo,
        gstin: gstin);
    _customerCollection.document(docId).setData(user.toMap(user));
  }

  Future<bool> isCustomerExists(String name) async {
    try {
      QuerySnapshot docs = await _customerCollection
          .where('name', isEqualTo: name)
          .getDocuments();

      List<DocumentSnapshot> doc = docs.documents;

      return doc.length == 0 ? false : true;
    } catch (e) {
      return false;
    }
  }

  Stream<QuerySnapshot> fetchAllCustomer() {
    return _customerCollection.snapshots();
  }
}
