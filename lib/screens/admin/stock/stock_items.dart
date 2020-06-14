import 'package:annaistore/models/product.dart';
import 'package:annaistore/resources/admin_methods.dart';
import 'package:annaistore/screens/custom_loading.dart';
import 'package:flutter/material.dart';

AdminMethods _adminMethods = AdminMethods();

class StockItems extends StatefulWidget {
  StockItems({Key key}) : super(key: key);

  @override
  _StockItemsState createState() => _StockItemsState();
}

class _StockItemsState extends State<StockItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: _adminMethods.fetchAllProduct(),
        builder: (context, snapshot) {
          var docs = snapshot.data.documents;
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                Product product = Product.fromMap(docs[index].data);
                return Column(
                  children: <Widget>[
                    Text(product.code),
                    StreamBuilder(
                        stream: _adminMethods
                            .getStockDetailsByProductId(product.id),
                        builder: (context, snapshot) {
                          var docs = snapshot.data.documents;
                          return Text("Hii");
                        })
                  ],
                );
              },
            );
          }
          return CustomCircularLoading();
        },
      ),
    );
  }
}
