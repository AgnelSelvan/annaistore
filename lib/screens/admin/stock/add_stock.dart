import 'package:annaistore/models/borrow.dart';
import 'package:annaistore/models/product.dart';
import 'package:annaistore/models/stock.dart';
import 'package:annaistore/models/unit.dart';
import 'package:annaistore/resources/admin_methods.dart';
import 'package:annaistore/screens/custom_loading.dart';
import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

AdminMethods _adminMethods = AdminMethods();

class AddStock extends StatefulWidget {
  AddStock({Key key}) : super(key: key);

  @override
  _AddStockState createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  TextEditingController _qtyController = TextEditingController();
  Unit selectedUnit;
  Product selectedProduct;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(10),
      children: <Widget>[
        SizedBox(height: 20),
        buildProductDropdown(),
        SizedBox(height: 20),
        buildUnitDropdown(),
        SizedBox(height: 20),
        buildQtyField(),
        SizedBox(height: 20),
        buildSubmitButton()
      ],
    );
  }

  buildSubmitButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.check_circle,
              color: Colors.green[200],
            ),
            onPressed: handleSubmitStock)
      ],
    );
  }

  handleSubmitStock() async {
    bool isExists = await _adminMethods.isStockExists(
        selectedProduct.id, selectedUnit.unitId);
    if (!isExists) {
      _adminMethods.addStockToDb(
          selectedProduct.id,
          selectedProduct.name,
          selectedUnit.unitId,
          selectedProduct.name,
          int.parse(_qtyController.text));
    } else {
      Stock stock;
      stock = await _adminMethods.getStockDetails(
          selectedProduct.id, selectedUnit.unitId);
      int updatedQty = stock.qty + int.parse(_qtyController.text);
      _adminMethods.updateStockById(stock.stockId, updatedQty);
    }
    setState(() {
      selectedProduct = null;
      selectedUnit = null;
      _qtyController.clear();
    });
    Dialogs.okDialog(context, "Successfull", "Added to stock successfully",
        Colors.green[200]);
  }

  Widget buildQtyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Quantity",
          style: Variables.inputLabelTextStyle,
        ),
        Container(
          height: 48,
          width: MediaQuery.of(context).size.width / 2,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            cursorColor: Variables.primaryColor,
            validator: (value) {
              if (value.isEmpty) return "You cannot have an empty Quantity!";
            },
            maxLines: 1,
            style: Variables.inputTextStyle,
            keyboardType: TextInputType.number,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: '240'),
            controller: _qtyController,
          ),
        ),
      ],
    );
  }

  Column buildUnitDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            "Unit",
            style: Variables.inputLabelTextStyle,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.yellow[100]),
          child: buildUnitDropdownButton(),
        ),
      ],
    );
  }

  StreamBuilder buildUnitDropdownButton() {
    return StreamBuilder<QuerySnapshot>(
        stream: _adminMethods.fetchAllUnit(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          } else {
            if (!snapshot.hasData) {
              return CustomCircularLoading();
            }

            return new DropdownButton<DocumentSnapshot>(
              dropdownColor: Colors.yellow[100],
              underline: SizedBox(),
              onChanged: (DocumentSnapshot newValue) {
                setState(() {
                  selectedUnit = Unit.fromMap(newValue.data);
                });
              },
              hint: selectedUnit == null
                  ? Text('Select Unit')
                  : Text(selectedUnit.unitId),
              items: snapshot.data.documents.map((DocumentSnapshot document) {
                return new DropdownMenuItem<DocumentSnapshot>(
                    value: document,
                    child: new Text(
                      document.data['unit'],
                    ));
              }).toList(),
            );
          }
          return CustomCircularLoading();
        });
  }

  Widget buildProductDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                "Product",
                style: Variables.inputLabelTextStyle,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.yellow[100]),
              child: StreamBuilder<QuerySnapshot>(
                  stream: _adminMethods.fetchAllProduct(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                    } else {
                      if (!snapshot.hasData) {
                        return CustomCircularLoading();
                      }

                      return new DropdownButton<DocumentSnapshot>(
                        dropdownColor: Colors.yellow[100],
                        underline: SizedBox(),
                        onChanged: (DocumentSnapshot newValue) async {
                          setState(() {
                            selectedProduct = Product.fromMap(newValue.data);
                          });
                        },
                        hint: selectedProduct == null
                            ? Text('Select Product')
                            : Text(selectedProduct.name),
                        items: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          return new DropdownMenuItem<DocumentSnapshot>(
                              value: document,
                              child: new Text(
                                document.data['name'],
                              ));
                        }).toList(),
                      );
                    }
                    return CustomCircularLoading();
                  }),
            ),
          ],
        ),
      ],
    );
  }
}
