import 'package:annaistore/models/user.dart';
import 'package:annaistore/models/yougave.dart';
import 'package:annaistore/resources/admin_methods.dart';
import 'package:annaistore/resources/auth_methods.dart';
import 'package:annaistore/screens/admin/borrow/single_borrow.dart';
import 'package:annaistore/screens/custom_loading.dart';
import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/bouncy_page_route.dart';
import 'package:annaistore/widgets/custom_appbar.dart';
import 'package:annaistore/widgets/custom_divider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

AdminMethods _adminMethods = AdminMethods();
AuthMethods _authMethods = AuthMethods();

class BorrowList extends StatefulWidget {
  BorrowList({Key key}) : super(key: key);

  @override
  _BorrowListState createState() => _BorrowListState();
}

class _BorrowListState extends State<BorrowList> {
  User currentUser;
  bool isLoading = false;

  getCurrentUser() async {
    setState(() {
      isLoading = true;
    });

    FirebaseUser firebaseUser = await _authMethods.getCurrentUser();
    User user = await _authMethods.getUserDetailsById(firebaseUser.uid);
    setState(() {
      currentUser = user;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.all(0),
                child: Column(
                  children: [
                    currentUser.role == 'admin'
                        ? StickyHeader(
                            header: buildStickyHeaderListView(context),
                            content: buildAdminStickyBodyListView())
                        : buildUserStickyBodyListView(),
                  ],
                ),
              ),
            ),
    );
  }

  buildUserStickyBodyListView() {
    return Text("Hii");
  }

  StreamBuilder buildAdminStickyBodyListView() {
    return StreamBuilder(
        stream: _adminMethods.getAllBorrowList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> docs = snapshot.data.documents;
            return ListView.separated(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: docs.length,
                separatorBuilder: (_, __) =>
                    CustomDivider(leftSpacing: 20, rightSpacing: 20),
                itemBuilder: (context, index) {
                  BorrowModel borrow = BorrowModel.fromMap(docs[index].data);
                  if (docs.length == 0) {
                    return ListTile(
                      title: Text("No borrows yet!"),
                    );
                  }
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          BouncyPageRoute(
                              widget: SingleBorrow(borrowId: borrow.borrowId)));
                    },
                    title: Text(borrow.customerName),
                    subtitle: Text(borrow.mobileNo),
                    leading: CircleAvatar(
                      backgroundColor: Variables.primaryColor,
                      child: Text(
                        borrow.customerName[0],
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    trailing: Text(
                      "₹ ${(borrow.price - borrow.givenAmount).toString()}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  );
                });
          }
          return CustomCircularLoading();
        });
  }

  Container buildStickyHeaderListView(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height / 4,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: FutureBuilder(
          future: _adminMethods.totalAmountYouWillGet(),
          builder: (context, snapshot) {
            return Container(
              height: double.infinity,
              width: MediaQuery.of(context).size.width / 2,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Variables.lightPrimaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "₹ ${snapshot.data.toString()}",
                    style: TextStyle(
                        color: Variables.lightGreyColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        letterSpacing: 1),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "You will get",
                    style: TextStyle(
                        color: Variables.lightGreyColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        letterSpacing: 1),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
