import 'package:annaistore/models/bill.dart';
import 'package:annaistore/resources/admin_methods.dart';
import 'package:annaistore/screens/custom_loading.dart';
import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/custom_appbar.dart';
import 'package:annaistore/widgets/custom_divider.dart';
import 'package:annaistore/widgets/dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

AdminMethods _adminMethods = AdminMethods();

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Bill> billsList = List();
  bool isLoading = false;

  getAllHistory() async {
    setState(() {
      isLoading = true;
    });
    List<DocumentSnapshot> docsList = await _adminMethods.getAllPaids();
    for (var doc in docsList) {
      Bill bill = await _adminMethods.getBillById(doc.data['bill_id']);
      billsList.add(bill);
    }
    setState(() {
      isLoading = false;
    });
    if (billsList.length == 0) {
      Dialogs.okDialog(context, 'Error', "No Paid Bill Yet!", Colors.red[200]);
    }
  }

  @override
  void initState() {
    super.initState();
    getAllHistory();
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
          : ListView.separated(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(billsList[index].customerName),
                  subtitle: Text("Bill No: ${billsList[index].billNo}"),
                  trailing: IconButton(
                      icon: Icon(
                        Icons.forward,
                        color: Variables.primaryColor,
                        size: 20,
                      ),
                      onPressed: () {}),
                  leading: CircleAvatar(
                    backgroundColor: Variables.primaryColor,
                    child: Text(
                      billsList[index].customerName[0],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) =>
                  CustomDivider(leftSpacing: 10, rightSpacing: 10),
              itemCount: billsList.length),
    );
  }
}
