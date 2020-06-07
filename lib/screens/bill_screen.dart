import 'dart:math';

import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/custom_appbar.dart';
import 'package:annaistore/widgets/custom_divider.dart';
import 'package:annaistore/widgets/header.dart';
import 'package:annaistore/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class BillScreen extends StatefulWidget {
  BillScreen({Key key}) : super(key: key);

  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  static Random random = new Random();
  static int randomNumber = random.nextInt(900000) + 100000;
  TextEditingController _billNumberController;
  TextEditingController _qtyController;
  TextEditingController _priceController;
  TextEditingController _taxController;
  TextEditingController _totalPriceController;
  String selectedCategory, selectedOption;
  bool viewVisible = false;
  List<String> category = [];
  List<String> qty = [];
  List<String> item = [];

  @override
  void initState() {
    super.initState();

    _billNumberController =
        TextEditingController(text: randomNumber.toString());
    _qtyController = TextEditingController();
    _priceController = TextEditingController();
    _taxController = TextEditingController();
    _totalPriceController = TextEditingController();
  }

  void showWidget() {
    print(viewVisible);
    setState(() {
      viewVisible = !viewVisible;
    });
    print(viewVisible);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Variables.lightGreyColor,
        appBar: CustomAppBar(
            bgColor: Colors.white,
            title: Text("Annai Store", style: Variables.appBarTextStyle),
            actions: null,
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Ionicons.ios_arrow_back,
                color: Variables.primaryColor,
              ),
            ),
            centerTitle: null),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 5),
              color: Colors.white,
              child: Card(
                elevation: 3,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  child: Column(
                    children: <Widget>[
                      BuildHeader(
                        text: "BILL",
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      buildBillNoField(),
                      SizedBox(
                        height: 15,
                      ),
                      category.isEmpty
                          ? Container()
                          : Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 20,
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Sr no.",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Variables.blackColor),
                                          ),
                                          CustomDivider(
                                              leftSpacing: 0, rightSpacing: 0)
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 60,
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Category",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Variables.blackColor),
                                          ),
                                          CustomDivider(
                                              leftSpacing: 0, rightSpacing: 0)
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 30,
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Qty",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Variables.blackColor),
                                          ),
                                          CustomDivider(
                                              leftSpacing: 0, rightSpacing: 0)
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 60,
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            "Items",
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Variables.blackColor),
                                          ),
                                          CustomDivider(
                                              leftSpacing: 0, rightSpacing: 0)
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      width: 20,
                                      height: 100,
                                      child: ListView.builder(
                                          itemCount: category.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Text((index + 1).toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color:
                                                        Variables.blackColor));
                                          }),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 50,
                                      height: 100,
                                      child: StreamBuilder<List<String>>(
                                          stream:
                                              Stream<List<String>>.fromIterable(
                                            [
                                              // category.ge
                                            ],
                                          ),
                                          builder: (context, snapshot) {
                                            return ListView.builder(
                                                itemCount: category.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Text(category[index],
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Variables
                                                              .blackColor));
                                                });
                                          }),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 30,
                                      height: 100,
                                      child: ListView.builder(
                                          itemCount: qty.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Text(qty[index],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color:
                                                        Variables.blackColor));
                                          }),
                                    ),
                                    Spacer(),
                                    Container(
                                      width: 70,
                                      height: 100,
                                      child: ListView.builder(
                                          itemCount: item.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(item[index],
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Variables
                                                            .blackColor)),
                                                GestureDetector(
                                                  onTap: () {
                                                    category.remove(
                                                        category[index]);
                                                    item.remove(item[index]);
                                                    qty.remove(qty[index]);
                                                    print(category);
                                                    print(item);
                                                    print(qty);
                                                  },
                                                  child: Icon(
                                                    FontAwesome.times_circle,
                                                    size: 20,
                                                    color: Colors.red[500],
                                                  ),
                                                )
                                              ],
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      SizedBox(
                        height: 15,
                      ),
                      viewVisible
                          ? Visibility(
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: viewVisible,
                              child: Container(
                                  child: Column(
                                children: <Widget>[
                                  buildCategoryField(),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  buildCategoryQtyField(),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              )))
                          : Container(),
                      Row(
                        mainAxisAlignment: viewVisible
                            ? MainAxisAlignment.spaceAround
                            : MainAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: showWidget,
                            child: Container(
                              width: 170,
                              decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(100)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
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
                                    "Add Product",
                                    style: TextStyle(
                                        letterSpacing: 1,
                                        fontSize: 16,
                                        color: Variables.blackColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                          if (viewVisible)
                            GestureDetector(
                              onTap: () {
                                category.add(selectedCategory);
                                qty.add(_qtyController.text);
                                item.add(selectedOption);
                                print(category);
                                print(qty);
                                print(item);
                                setState(() {
                                  viewVisible = false;
                                });
                              },
                              child: Icon(
                                Icons.check_circle,
                                size: 30,
                                color: Colors.green[200],
                              ),
                            )
                          else
                            Container(),
                        ],
                      ),
                      SizedBox(height: 15),
                      category.isEmpty
                          ? Container()
                          : Container(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Price:         ",
                                    style:
                                        TextStyle(color: Variables.blackColor),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 48,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      decoration: BoxDecoration(
                                          color: Colors.yellow[100],
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: TextField(
                                        maxLines: 1,
                                        style: Variables.inputTextStyle,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Price'),
                                        controller: _priceController,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(height: 15),
                      category.isEmpty
                          ? Container()
                          : Container(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Tax:          ",
                                    style:
                                        TextStyle(color: Variables.blackColor),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 48,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      decoration: BoxDecoration(
                                          color: Colors.yellow[100],
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: TextField(
                                        maxLines: 1,
                                        style: Variables.inputTextStyle,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Tax'),
                                        controller: _taxController,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(height: 15),
                      category.isEmpty
                          ? Container()
                          : Container(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "Total Price:",
                                    style:
                                        TextStyle(color: Variables.blackColor),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 48,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      decoration: BoxDecoration(
                                          color: Colors.yellow[100],
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: TextField(
                                        maxLines: 1,
                                        style: Variables.inputTextStyle,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Total Price'),
                                        controller: _totalPriceController,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Row buildCategoryQtyField() {
    return Row(
      children: <Widget>[
        Text(
          "Qty:         ",
          style: TextStyle(color: Variables.blackColor),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.yellow[100]),
          child: Container(
            width: 50,
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(8)),
            child: TextField(
                maxLines: 1,
                style: Variables.inputTextStyle,
                keyboardType: TextInputType.number,
                decoration:
                    InputDecoration(border: InputBorder.none, hintText: 'Qty'),
                controller: _qtyController),
          ),
        ),
        SizedBox(width: 10),
        Text(
          "/",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w100),
        ),
        SizedBox(width: 10),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.yellow[100]),
            child: buildBoxOrThreadDropdownButton(<String>['Boxes', 'Thread'])),
      ],
    );
  }

  Row buildCategoryField() {
    return Row(
      children: <Widget>[
        Text(
          "Category: ",
          style: TextStyle(color: Variables.blackColor),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.yellow[100]),
          child: buildDropdownButton(
              <String>['Threads', 'Canvas', 'Rolls', 'Laice']),
        )
      ],
    );
  }

  DropdownButton<String> buildBoxOrThreadDropdownButton(
      List<String> dropDownList) {
    return DropdownButton(
      icon: Icon(
        Icons.arrow_drop_down,
        size: 20,
      ),
      dropdownColor: Colors.yellow[100],
      underline: SizedBox(),
      items: dropDownList.map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(
            value,
            style: TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
      onChanged: (String value) {
        setState(() {
          selectedOption = value;
        });

        final snackBar = customSnackBar('Selected product value is $value', Variables.blackColor);

        _scaffoldKey.currentState.showSnackBar(snackBar);
      },
      value: selectedOption,
      isExpanded: false,
      hint: Text(
        "Select an option",
        style: TextStyle(fontSize: 12),
      ),
    );
  }

  DropdownButton<String> buildDropdownButton(List<String> dropDownList) {
    return DropdownButton(
      dropdownColor: Colors.yellow[100],
      underline: SizedBox(),
      items: dropDownList.map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),
      onChanged: (String value) {
        setState(() {
          selectedCategory = value;
        });

        final snackBar = SnackBar(
          content: Text(
            'Selected Category value is $value',
            style: TextStyle(color: Variables.blackColor),
          ),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.yellow[100],
        );

        _scaffoldKey.currentState.showSnackBar(snackBar);
      },
      value: selectedCategory,
      isExpanded: false,
      hint: Text("Select an option"),
    );
  }

  Row buildBillNoField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Bill No: ",
          style: TextStyle(color: Variables.blackColor),
        ),
        Expanded(
          child: Container(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(8)),
            child: TextField(
              maxLines: 1,
              style: Variables.inputTextStyle,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Bill number'),
              controller: _billNumberController,
            ),
          ),
        ),
      ],
    );
  }
}
