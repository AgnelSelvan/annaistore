import 'package:annaistore/models/unit.dart';
import 'package:annaistore/screens/custom_loading.dart';
import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/custom_appbar.dart';
import 'package:annaistore/widgets/custom_divider.dart';
import 'package:annaistore/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class AddProduct extends StatefulWidget {
  AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController _codeFieldController = TextEditingController();
  TextEditingController _nameFieldController = TextEditingController();
  TextEditingController _hsnFieldController = TextEditingController();
  // TextEditingController _hsnFieldController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool viewVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: buildSymbolCard(),
            ),
          ],
        ),
      ),
    );
  }

  void showWidget() {
    print(viewVisible);
    setState(() {
      viewVisible = !viewVisible;
    });
    print(viewVisible);
  }

  Card buildSymbolCard() {
    return Card(
      elevation: 3,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BuildHeader(
                text: "Add Product",
              ),
              SizedBox(
                height: 15,
              ),
              StreamBuilder(
                  // stream: _adminMethods.fetchAllUnit(),
                  builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.documents.length != 0) {
                    return Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Container(
                                    width: 95,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Symbol',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Variables.blackColor),
                                        ),
                                        CustomDivider(
                                            leftSpacing: 2, rightSpacing: 2)
                                      ],
                                    )),
                                Container(
                                    width: 95,
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          "Formal Name",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Variables.blackColor),
                                        ),
                                        CustomDivider(
                                            leftSpacing: 2, rightSpacing: 2)
                                      ],
                                    )),
                                Container(
                                  width: 5,
                                )
                              ],
                            ),
                            Container(
                              width: double.infinity,
                              height: 100,
                              child: StreamBuilder(
                                // stream: _adminMethods.fetchAllUnit(),
                                builder: (context, snapshot) {
                                  var docs = snapshot.data.documents;
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                      physics: BouncingScrollPhysics(),
                                      itemCount: docs.length,
                                      itemBuilder: (context, index) {
                                        Unit unit =
                                            Unit.fromMap(docs[index].data);
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Container(
                                                width: 95,
                                                height: 22,
                                                child: Text(unit.unit,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Variables
                                                            .blackColor))),
                                            Container(
                                                width: 95,
                                                height: 22,
                                                child: Text(unit.formalName,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Variables
                                                            .blackColor))),
                                            GestureDetector(
                                              // onTap: () {
                                              //   handleDeleteUnit(
                                              //       unit.unitId);
                                              // },
                                              child: Container(
                                                  width: 5,
                                                  height: 20,
                                                  child: Icon(
                                                    FontAwesome.times_circle,
                                                    size: 20,
                                                    color: Colors.red,
                                                  )),
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  }
                                  return CustomCircularLoading();
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Click Add Unit for adding units!",
                            style: TextStyle(
                                color: Variables.blackColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.5),
                          ),
                        ),
                        SizedBox(height: 20)
                      ],
                    );
                  }
                }
                return CustomCircularLoading();
              }),
              viewVisible ? buildVisibility() : Container(),
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

  GestureDetector buildSubmissionButton() {
    return GestureDetector(
      // onTap: addUnitToDb,
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
              "Add Unit",
              style: TextStyle(
                  letterSpacing: 1, fontSize: 16, color: Variables.blackColor),
            )
          ],
        ),
      ),
    );
  }

  Visibility buildVisibility() {
    return Visibility(
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        visible: viewVisible,
        child: Container(
            child: Column(
          children: <Widget>[
            buildCodeField(),
            SizedBox(
              height: 20,
            ),
            buildFormalNameField(),
            SizedBox(
              height: 20,
            ),
          ],
        )));
  }

  Widget buildFormalNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Formal Name",
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
              if (value.isEmpty) return "You cannot have an empty formal name!";
            },
            maxLines: 1,
            style: Variables.inputTextStyle,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: 'bx'),
            controller: _nameFieldController,
          ),
        ),
      ],
    );
  }

  Widget buildCodeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Code",
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
              if (value.isEmpty) return "You cannot have an empty code!";
            },
            maxLines: 1,
            style: Variables.inputTextStyle,
            decoration:
                InputDecoration(border: InputBorder.none, hintText: 'box'),
            controller: _codeFieldController,
          ),
        ),
      ],
    );
  }
}
