import 'package:annaistore/constants/strings.dart';
import 'package:annaistore/models/category.dart';
import 'package:annaistore/models/product.dart';
import 'package:annaistore/models/stock.dart';
import 'package:annaistore/models/sub-category.dart';
import 'package:annaistore/models/unit.dart';
import 'package:annaistore/models/user.dart';
import 'package:annaistore/models/yougave.dart';
import 'package:annaistore/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminMethods {
  static final _firestore = Firestore.instance;

  CollectionReference _unitCollection = _firestore.collection(UNITS_STRING);
  CollectionReference _categoryCollection =
      _firestore.collection(CATEGORIES_STRING);
  CollectionReference _subCategoryCollection =
      _firestore.collection('sub_categories');
  CollectionReference _productCollection = _firestore.collection('product');
  CollectionReference _customerCollection = _firestore.collection('customers');
  CollectionReference _borrowsCollection = _firestore.collection('borrows');
  CollectionReference _stocksCollection = _firestore.collection('stocks');

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
      int sellingRate, String hsnCode, String unit, int unitQty) async {
    String docId = _productCollection.document().documentID;
    Product product = Product(
        id: docId,
        name: name,
        code: code,
        hsnCode: hsnCode,
        unit: unit,
        purchaseRate: purchaseRate,
        sellingRate: sellingRate,
        unitQty: unitQty);
    _productCollection.document(docId).setData(product.toMap(product));
    addStockToDb(docId, code, 0);
  }

  Future<String> getUnitNameByUnitId(String unitId) async {
    DocumentSnapshot doc = await _unitCollection.document(unitId).get();
    Unit unit = Unit.fromMap(doc.data);
    return unit.unit;
  }

  Future<bool> isProductExists(String code) async {
    try {
      QuerySnapshot docs = await _productCollection
          .where('code', isEqualTo: code)
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
        mobileNo: mobileNo.toString().trim(),
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

  Future<Category> getTaxFromHsn(String hsnCode) async {
    QuerySnapshot docs = await _categoryCollection
        .where('hsn_code', isEqualTo: hsnCode)
        .getDocuments();
    List<DocumentSnapshot> doc = docs.documents;
    print('doc:${doc[0].data["tax"]}');

    Category category = Category.fromMap(doc[0].data);

    return category;
  }

  // Future<void> addBorrowToDb(Borrow borrow) async {
  //   String docId = _borrowsCollection.document().documentID;
  //   await _borrowsCollection.document(docId).setData(borrow.toMap(borrow));
  // }

  Future<void> addStockToDb(
      String productId, String productCode, int qty) async {
    String docId = Utils.getDocId();
    Stock stock = Stock(
        stockId: docId,
        productId: productId,
        productCode: productCode,
        qty: qty);
    _stocksCollection.document(docId).setData(stock.toMap(stock));
  }

  Future<bool> isStockExists(String productId) async {
    QuerySnapshot docs = await _stocksCollection
        .where('product_id', isEqualTo: productId)
        .getDocuments();
    return docs.documents.length == 0 ? false : true;
  }

  Future<Stock> getStockDetails(String productId) async {
    Stock stock;
    print(productId);
    QuerySnapshot docs = await _stocksCollection
        .where('product_id', isEqualTo: productId)
        .getDocuments();
    List<DocumentSnapshot> doc = docs.documents;
    print(doc.length);
    if (doc.length == 1) {
      print("Yes");
      stock = Stock.fromMap(doc[0].data);
    }

    return stock;
  }

  Future<void> updateStockById(String stockId, int qty) async {
    await _stocksCollection.document(stockId).updateData({'quantity': qty});
  }

  Stream<QuerySnapshot> getStockDetailsByProductId(String productId) {
    Stream<QuerySnapshot> docs =
        _stocksCollection.where('product_id', isEqualTo: productId).snapshots();
    // print(docs.length);
    return docs;
  }

  Stream<QuerySnapshot> getProductFromHsn(String hsnCode) {
    return _productCollection.where('hsn_code', isEqualTo: hsnCode).snapshots();
  }

  Stream<QuerySnapshot> getCategoryFromHsn(String hsnCode) {
    return _productCollection.where('hsn_code', isEqualTo: hsnCode).snapshots();
  }

  Future<bool> isQrExists(String qrCode) async {
    QuerySnapshot docs = await _productCollection
        .where('code', isEqualTo: qrCode)
        .getDocuments();

    return docs.documents.length == 0 ? false : true;
  }

  Future<Product> getProductDetailsByQrCode(String qrCode) async {
    QuerySnapshot docs = await _productCollection
        .where('code', isEqualTo: qrCode)
        .getDocuments();
    List<DocumentSnapshot> doc = docs.documents;
    Product product = Product.fromMap(doc[0].data);
    return product;
  }

  Future<void> addBorrowToDb(BorrowModel borrowModel) async {
    await _borrowsCollection
        .document(borrowModel.borrowId)
        .setData(borrowModel.toMap(borrowModel));
  }

  Stream<QuerySnapshot> getAllBorrowList() {
    return _borrowsCollection.snapshots();
  }

  Future<int> totalAmountYouWillGet() async {
    QuerySnapshot docs = await _borrowsCollection.getDocuments();
    List<DocumentSnapshot> docList = docs.documents.toList();
    int sum = 0;
    for (var i = 0; i < docList.length; i++) {
      BorrowModel borrow = BorrowModel.fromMap(docList[i].data);
      sum = sum + (borrow.price - borrow.givenAmount);
    }
    return sum;
  }

  Future<BorrowModel> getBorrowById(String borrowId) async {
    DocumentSnapshot doc = await _borrowsCollection.document(borrowId).get();
    BorrowModel borrowModel = BorrowModel.fromMap(doc.data);
    return borrowModel;
  }

  Future<Product> getProductDetailsFromProductId(String productId) async {
    DocumentSnapshot doc = await _productCollection.document(productId).get();

    Product product = Product.fromMap(doc.data);
    return product;
  }

  Future<List<DocumentSnapshot>> getBorrowListOfMe(User currentUser) async {
    QuerySnapshot docs = await _borrowsCollection
        .where('mobile_no', isEqualTo: currentUser.mobileNo.trim())
        .getDocuments();

    return docs.documents.toList();
  }
}
