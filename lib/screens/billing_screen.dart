import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/custom_appbar.dart';
import 'package:annaistore/widgets/header.dart';
import 'package:flutter/material.dart';

class BillingScreen extends StatefulWidget {
  BillingScreen({Key key}) : super(key: key);

  @override
  _BillingScreenState createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        bgColor: Colors.white,
        title: Text("Annai Store", style: Variables.appBarTextStyle),
        actions: <Widget>[],
        leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Variables.primaryColor,
            ),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            }),
        centerTitle: null,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Center(
                child: BuildHeader(text: 'Billing'),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
