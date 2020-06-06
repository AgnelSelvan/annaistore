import 'package:annaistore/models/user.dart';
import 'package:annaistore/resources/auth_methods.dart';
import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/custom_appbar.dart';
import 'package:annaistore/widgets/custom_drawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthMethods _authMethods = AuthMethods();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User currentUser;

  @override
  void initState() {
    super.initState();
    _authMethods.getCurrentUser().then((FirebaseUser user) {
      setState(() {
        currentUser = User(
            uid: user.uid, name: user.displayName, profilePhoto: user.photoUrl);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        bgColor: Colors.yellow[50],
        title: Text("Annai Store", style: Variables.appBarTextStyle),
        actions: null,
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
      drawer: customDrawer(context, currentUser.profilePhoto, currentUser.name),
      backgroundColor: Colors.yellow[50],
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            color: Colors.yellow[50],
            child: Column(
              children: <Widget>[
                SizedBox(height: 30),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CachedNetworkImage(imageUrl: currentUser.profilePhoto),
                ),
                SizedBox(height: 10),
                Text(
                  currentUser.name,
                  style: TextStyle(
                    color: Variables.blackColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    letterSpacing: 0.7,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white),
                  child: Text(
                    "agnelselvan007",
                    style: TextStyle(color: Variables.primaryColor),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(34))),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            FontAwesome.stack_overflow,
                            size: 16,
                            color: Variables.primaryColor,
                          ),
                          title: Text(
                            "Add Stock",
                            style: TextStyle(
                                color: Variables.blackColor,
                                fontSize: 20,
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.edit,
                            size: 16,
                            color: Variables.primaryColor,
                          ),
                          title: Text(
                            "Edit Account",
                            style: TextStyle(
                                color: Variables.blackColor,
                                fontSize: 20,
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.report,
                            size: 16,
                            color: Variables.primaryColor,
                          ),
                          title: Text(
                            "Reports",
                            style: TextStyle(
                                color: Variables.blackColor,
                                fontSize: 20,
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            FontAwesome.product_hunt,
                            size: 16,
                            color: Variables.primaryColor,
                          ),
                          title: Text(
                            "Add Product",
                            style: TextStyle(
                                color: Variables.blackColor,
                                fontSize: 20,
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.chat,
                            size: 16,
                            color: Variables.primaryColor,
                          ),
                          title: Text(
                            "Give your suggestion",
                            style: TextStyle(
                                color: Variables.blackColor,
                                fontSize: 20,
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
