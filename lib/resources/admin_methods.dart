import 'dart:math';

import 'package:annaistore/constants/strings.dart';
import 'package:annaistore/models/category.dart';
import 'package:annaistore/models/unit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminMethods {
  static final _firestore = Firestore.instance;

  CollectionReference _unitCollection = _firestore.collection(UNITS_STRING);
  CollectionReference _categoryCollection =
      _firestore.collection(CATEGORIES_STRING);

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
    String docId = await _categoryCollection.document().documentID;
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

  Future<void> addSubCategoryToDb(){}

}
