import 'package:annaistore/resources/admin_methods.dart';
import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/custom_appbar.dart';
import 'package:annaistore/widgets/dialogs.dart';
import 'package:annaistore/widgets/header.dart';
import 'package:annaistore/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../custom_loading.dart';

AdminMethods _adminMethods = AdminMethods();

class BorrowScreen extends StatefulWidget {
  BorrowScreen({Key key}) : super(key: key);

  @override
  _BorrowScreenState createState() => _BorrowScreenState();
}

class _BorrowScreenState extends State<BorrowScreen> {
  TextEditingController _emailFieldController = TextEditingController();
  TextEditingController _nameFieldController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _mobileNoController = TextEditingController();
  TextEditingController _gstinController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool viewVisible = false;
  bool _checkBoxValue = false;
  String currentState;
  String currentUnit;
  String currentName;
  String currentProduct;
  var productList = new List();
  var qtyList = new List();

  List<String> state = [
    'Maharashtra',
    'Tamil Nadu',
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
            title: Text("Annai Store", style: Variables.appBarTextStyle),
            actions: null,
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Variables.primaryColor,
                  size: 16,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            centerTitle: true,
            bgColor: Colors.white),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 5),
                color: Colors.white,
                child: buildCustomerCard(),
              ),
            ],
          ),
        ));
  }

  createAlertDialog(BuildContext context, String currentProduct) {
    TextEditingController qtyController = TextEditingController();

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text("Enter Quantity"),
            content: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(8)),
              child: TextFormField(
                cursorColor: Variables.primaryColor,
                validator: (value) {
                  if (value.isEmpty)
                    return "You cannot have an empty Purchase Price!";
                  if (value.length != 6) return "Enter valid pincode!";
                },
                maxLines: 1,
                keyboardType: TextInputType.number,
                style: Variables.inputTextStyle,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Quantity'),
                controller: qtyController,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(DialogAction.Abort);
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Variables.primaryColor),
                ),
              ),
              RaisedButton(
                elevation: 0,
                color: Variables.primaryColor,
                onPressed: () {
                  if (!productList.contains(currentProduct)) {
                    productList.add(currentProduct);
                    qtyList.add(int.parse(qtyController.text));
                  }
                  Navigator.of(context).pop(DialogAction.Abort);
                  print(productList);
                  print(qtyList);
                },
                child: Text(
                  "Yes",
                  style: TextStyle(color: Variables.lightGreyColor),
                ),
              )
            ],
          );
        });
  }

  handleDeleteUnit(String unitId) {
    _adminMethods.deleteUnit(unitId);
    final snackBar =
        customSnackBar('Delete Successfull!', Variables.blackColor);
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void showWidget() {
    print(viewVisible);
    setState(() {
      viewVisible = !viewVisible;
    });
    print(viewVisible);
  }

  addCustomerToDb() {
    print(productList);
  }

  Card buildCustomerCard() {
    return Card(
      elevation: 3,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BuildHeader(
                    text: "Customer",
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                          activeColor: Variables.primaryColor,
                          focusColor: Variables.primaryColor,
                          value: _checkBoxValue,
                          onChanged: (bool value) {
                            print(value);
                            setState(() {
                              _checkBoxValue = value;
                            });
                          }),
                      Text("Regular Customer")
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              viewVisible ? buildCustomer() : Container(),
              Row(
                mainAxisAlignment: viewVisible
                    ? MainAxisAlignment.spaceAround
                    : MainAxisAlignment.center,
                children: <Widget>[
                  buildCustomModelButton(),
                  if (viewVisible) buildSubmissionButton() else Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildCustomer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildVisibility(),
        buildProductDropdown(),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  GestureDetector buildSubmissionButton() {
    return GestureDetector(
      onTap: addCustomerToDb,
      child: Icon(
        Icons.check_circle,
        size: 30,
        color: Colors.green[200],
      ),
    );
  }

  GestureDetector buildCustomModelButton() {
    return GestureDetector(
      onTap: () {
        showWidget();
      },
      child: Container(
        width: 170,
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(100)),
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.yellow[100]),
              child: Icon(
                Icons.add,
                color: Variables.blackColor,
              ),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              "Add Borrow",
              style: TextStyle(
                  letterSpacing: 1, fontSize: 16, color: Variables.blackColor),
            )
          ],
        ),
      ),
    );
  }

  Visibility buildVisibility() {
    return _checkBoxValue
        ? Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: viewVisible,
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[buildRegularCustomerDetails()],
            )))
        : Visibility(
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            visible: viewVisible,
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildNameField(),
                SizedBox(
                  height: 20,
                ),
                buildEmailField(),
                SizedBox(
                  height: 20,
                ),
                buildAddressField(),
                SizedBox(
                  height: 20,
                ),
                buildStateDropDown(),
                SizedBox(
                  height: 20,
                ),
                buildPincodeField(),
                SizedBox(
                  height: 20,
                ),
                buildMobileNoField(),
                SizedBox(
                  height: 20,
                ),
                buildGSTINField(),
                SizedBox(
                  height: 20,
                ),
              ],
            )));
  }

  buildRegularCustomerDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildNameDropdown(),
        SizedBox(
          height: 20,
        ),
        buildEmailField(),
        SizedBox(
          height: 20,
        ),
        buildAddressField(),
        SizedBox(
          height: 20,
        ),
        buildStateDropDown(),
        SizedBox(
          height: 20,
        ),
        buildPincodeField(),
        SizedBox(
          height: 20,
        ),
        buildMobileNoField(),
        SizedBox(
          height: 20,
        ),
        buildGSTINField(),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget buildProductList() {
    return Container(
      height: 300,
      padding: EdgeInsets.all(10),
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                  color: Variables.greyColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(productList[index]),
                    Text('(${qtyList[index]})'),
                    IconButton(
                        icon: Icon(
                          FontAwesome.times_circle,
                          color: Colors.red[200],
                        ),
                        onPressed: null)
                  ],
                ),
              ),
            );
          },
          itemCount: productList.length),
    );
  }

  Widget buildQtyList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Quantity",
          style: Variables.inputLabelTextStyle,
        ),
        Container(
          height: 48,
          width: 100,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            cursorColor: Variables.primaryColor,
            validator: (value) {
              if (value.isEmpty)
                return "You cannot have an empty Purchase Price!";
              if (value.length != 6) return "Enter valid pincode!";
            },
            maxLines: 1,
            keyboardType: TextInputType.number,
            style: Variables.inputTextStyle,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: 'Quantity'),
            controller: _pincodeController,
          ),
        ),
      ],
    );
  }

  Widget buildProductDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        currentProduct == null ? Container() : buildProductList(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            onChanged: (DocumentSnapshot newValue) {
                              setState(() {
                                currentProduct = newValue.data['name'];
                                createAlertDialog(context, currentProduct);
                              });
                              // print(currentProduct);
                            },
                            hint: currentProduct == null
                                ? Text('Select Name')
                                : Text(currentProduct),
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
            // buildQtyList()
          ],
        ),
      ],
    );
  }

  buildNameDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            "Name",
            style: Variables.inputLabelTextStyle,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.yellow[100]),
          child: StreamBuilder<QuerySnapshot>(
              stream: _adminMethods.fetchAllCustomer(),
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
                    onChanged: (DocumentSnapshot newValue) {
                      setState(() {
                        currentName = newValue.data['name'];
                        _emailFieldController =
                            TextEditingController(text: newValue.data['email']);
                        _addressController = TextEditingController(
                            text: newValue.data['address']);
                        currentState = newValue.data['state'];
                        _pincodeController = TextEditingController(
                            text: newValue.data['pincode']);
                        _gstinController =
                            TextEditingController(text: newValue.data['gstin']);
                      });
                    },
                    hint: currentName == null
                        ? Text('Select Name')
                        : Text(currentName),
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
                  currentUnit = newValue.data['unit'];
                });
              },
              hint:
                  currentUnit == null ? Text('Select Unit') : Text(currentUnit),
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

  Column buildStateDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            "State",
            style: Variables.inputLabelTextStyle,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.yellow[100]),
          child: buildStateDropdownButton(),
        ),
      ],
    );
  }

  Widget buildStateDropdownButton() {
    return DropdownButton<String>(
      dropdownColor: Colors.yellow[100],
      underline: SizedBox(),
      onChanged: (String newValue) {
        setState(() {
          currentState = newValue;
        });
      },
      hint: currentState == null ? Text('Select State') : Text(currentState),
      items: state.map((String document) {
        return new DropdownMenuItem<String>(
            value: document,
            child: new Text(
              document,
            ));
      }).toList(),
    );
  }

  Widget buildMobileNoField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Mobile No.",
          style: Variables.inputLabelTextStyle,
        ),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            cursorColor: Variables.primaryColor,
            validator: (value) {
              // if (value.isEmpty)
              //   return "You cannot have an empty Selling Price!";
              if (value.length != 10) return "Enter a valid mobile number!";
            },
            maxLines: 1,
            style: Variables.inputTextStyle,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: '1234567890'),
            controller: _mobileNoController,
          ),
        ),
      ],
    );
  }

  Widget buildPincodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Pincode",
          style: Variables.inputLabelTextStyle,
        ),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            cursorColor: Variables.primaryColor,
            validator: (value) {
              if (value.isEmpty)
                return "You cannot have an empty Purchase Price!";
              if (value.length != 6) return "Enter valid pincode!";
            },
            maxLines: 1,
            keyboardType: TextInputType.number,
            style: Variables.inputTextStyle,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: '123456'),
            controller: _pincodeController,
          ),
        ),
      ],
    );
  }

  Widget buildGSTINField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "GSTIN",
          style: Variables.inputLabelTextStyle,
        ),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            cursorColor: Variables.primaryColor,
            maxLines: 1,
            style: Variables.inputTextStyle,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: 'ABCD1234'),
            controller: _gstinController,
          ),
        ),
      ],
    );
  }

  Widget buildAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Address",
          style: Variables.inputLabelTextStyle,
        ),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            cursorColor: Variables.primaryColor,
            validator: (value) {
              if (value.isEmpty) return "You cannot have an empty address!";
            },
            maxLines: 1,
            style: Variables.inputTextStyle,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: '53/2, example'),
            controller: _addressController,
          ),
        ),
      ],
    );
  }

  Widget buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Name",
          style: Variables.inputLabelTextStyle,
        ),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            cursorColor: Variables.primaryColor,
            validator: (value) {
              if (value.isEmpty) return "You cannot have an empty name!";
            },
            maxLines: 1,
            style: Variables.inputTextStyle,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: 'Customer'),
            controller: _nameFieldController,
          ),
        ),
      ],
    );
  }

  Widget buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Email",
          style: Variables.inputLabelTextStyle,
        ),
        Container(
          height: 48,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(8)),
          child: TextFormField(
            cursorColor: Variables.primaryColor,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value.isEmpty) return "You cannot have an empty Email!";
            },
            maxLines: 1,
            style: Variables.inputTextStyle,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'customer@gmail.com'),
            controller: _emailFieldController,
          ),
        ),
      ],
    );
  }
}
