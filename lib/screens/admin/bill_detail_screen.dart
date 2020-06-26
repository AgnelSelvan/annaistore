import 'package:annaistore/models/bill.dart';
import 'package:annaistore/resources/admin_methods.dart';
import 'package:annaistore/screens/custom_loading.dart';
import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/custom_appbar.dart';
import 'package:annaistore/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

AdminMethods _adminMethods = AdminMethods();

class BillDetails extends StatefulWidget {
  final String billId;
  BillDetails({this.billId});

  @override
  _BillDetailsState createState() => _BillDetailsState();
}

class _BillDetailsState extends State<BillDetails> {
  Bill currentBill;
  bool isLoading = false;

  getBillDetails() async {
    setState(() {
      isLoading = true;
    });
    Bill _currentBill = await _adminMethods.getBillById(widget.billId);
    setState(() {
      currentBill = _currentBill;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getBillDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: isLoading
          ? CustomCircularLoading()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  Center(child: BuildHeader(text: 'Bill Details')),
                  SizedBox(
                    height: 40,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Bill No: ',
                              style: Variables.inputTextStyle,
                            ),
                            Text(currentBill.billNo)
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Customer Name: ',
                              style: Variables.inputTextStyle,
                            ),
                            Text(currentBill.customerName)
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text("Product:  "),
                            Row(
                              children: List.generate(
                                currentBill.productList.length,
                                (index) => Text(
                                    "${currentBill.productList[index]}(${currentBill.qtyList[index]}) ,"),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              'Price: ',
                              style: Variables.inputTextStyle,
                            ),
                            Text(currentBill.price.toString())
                          ],
                        ),
                        currentBill.isTax ? SizedBox(height: 20) : Container(),
                        currentBill.isTax
                            ? Row(
                                children: [
                                  Text(
                                    'Tax: ',
                                    style: Variables.inputTextStyle,
                                  ),
                                  Text("Hii"),
                                ],
                              )
                            : Text("No Tax")
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
