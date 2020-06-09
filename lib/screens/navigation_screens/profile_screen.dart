import 'package:annaistore/main.dart';
import 'package:annaistore/models/user.dart';
import 'package:annaistore/resources/auth_methods.dart';
import 'package:annaistore/screens/admin/add_category.dart';
import 'package:annaistore/screens/admin/add_product.dart';
import 'package:annaistore/screens/admin/add_regular_customer.dart';
import 'package:annaistore/screens/admin/add_sub_category.dart';
import 'package:annaistore/screens/admin/add_unit.dart';
import 'package:annaistore/screens/admin/borrow.dart';
import 'package:annaistore/screens/auth_screen.dart';
import 'package:annaistore/screens/custom_loading.dart';
import 'package:annaistore/screens/edit_profile_screen.dart';
import 'package:annaistore/screens/root_screen.dart';
import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/bouncy_page_route.dart';
import 'package:annaistore/widgets/custom_appbar.dart';
import 'package:annaistore/widgets/custom_drawer.dart';
import 'package:annaistore/widgets/dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

AuthMethods _authMethods = AuthMethods();

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthMethods _authMethods = AuthMethods();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User currentUser;
  String currentUserId;

  @override
  void initState() {
    super.initState();
    _authMethods.getCurrentUser().then((FirebaseUser user) {
      setState(() {
        currentUserId = user.uid;
      });
      print("Haha:$currentUserId");
    });
    _authMethods.getUserDetailsById(currentUserId).then((User user) {
      setState(() {
        currentUser = user;
      });
    });
    print("currentUser: $currentUser");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        bgColor: Colors.yellow[50],
        title: Text("Annai Store", style: Variables.appBarTextStyle),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                FontAwesome.power_off,
                size: 16,
                color: Colors.red[200],
              ),
              onPressed: () async {
                await Dialogs.yesAbortDialog(
                    context, "Logout", "Are you sure want to logout?", () {
                  _authMethods.signOut();
                  Navigator.push(
                      context, BouncyPageRoute(widget: AuthScreen()));
                });
              })
        ],
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
      drawer: customDrawer(context, currentUserId),
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
                FutureBuilder(
                    future: _authMethods.getUserDetailsById(currentUserId),
                    builder: (context, snapshot) {
                      User currentUser = snapshot.data;
                      if (snapshot.hasData) {
                        return Column(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                  imageUrl: currentUser.profilePhoto),
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 7, horizontal: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white),
                              child: Text(
                                currentUser.username,
                                style: TextStyle(color: Variables.primaryColor),
                              ),
                            ),
                          ],
                        );
                      }
                      return CustomCircularLoading();
                    }),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(50))),
                    child: ListView(
                      physics: BouncingScrollPhysics(),
                      children: <Widget>[
                        ExpandableTheme(
                            data: const ExpandableThemeData(
                              iconColor: Colors.yellow,
                              useInkWell: true,
                            ),
                            child: ExpandableNotifier(
                                child: ScrollOnExpand(
                                    scrollOnExpand: true,
                                    scrollOnCollapse: false,
                                    child: ExpandablePanel(
                                      theme: const ExpandableThemeData(
                                        headerAlignment:
                                            ExpandablePanelHeaderAlignment
                                                .center,
                                        tapBodyToCollapse: true,
                                      ),
                                      header: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.add,
                                              size: 16,
                                              color: Variables.primaryColor,
                                            ),
                                            title: Text("Add",
                                                style: TextStyle(
                                                    color: Variables.blackColor,
                                                    fontSize: 18,
                                                    letterSpacing: 0.3,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          )),
                                      expanded: Column(
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
                                                  fontSize: 18,
                                                  letterSpacing: 0.3,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          ListTile(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  BouncyPageRoute(
                                                      widget: AddCategory()));
                                            },
                                            leading: Icon(
                                              FontAwesome.list_alt,
                                              size: 16,
                                              color: Variables.primaryColor,
                                            ),
                                            title: Text(
                                              "Add Category",
                                              style: TextStyle(
                                                  color: Variables.blackColor,
                                                  fontSize: 18,
                                                  letterSpacing: 0.3,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          ListTile(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  BouncyPageRoute(
                                                      widget:
                                                          AddSubCategory()));
                                            },
                                            leading: Icon(
                                              FontAwesome.list_alt,
                                              size: 16,
                                              color: Variables.primaryColor,
                                            ),
                                            title: Text(
                                              "Add Sub-Category",
                                              style: TextStyle(
                                                  color: Variables.blackColor,
                                                  fontSize: 18,
                                                  letterSpacing: 0.3,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          ListTile(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  BouncyPageRoute(
                                                      widget: AddProduct()));
                                            },
                                            leading: Icon(
                                              FontAwesome.product_hunt,
                                              size: 16,
                                              color: Variables.primaryColor,
                                            ),
                                            title: Text(
                                              "Add Product",
                                              style: TextStyle(
                                                  color: Variables.blackColor,
                                                  fontSize: 18,
                                                  letterSpacing: 0.3,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          ListTile(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  BouncyPageRoute(
                                                      widget: AddUnit()));
                                            },
                                            leading: Icon(
                                              Icons.ac_unit,
                                              size: 16,
                                              color: Variables.primaryColor,
                                            ),
                                            title: Text(
                                              "Add Unit",
                                              style: TextStyle(
                                                  color: Variables.blackColor,
                                                  fontSize: 18,
                                                  letterSpacing: 0.3,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                          ListTile(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  BouncyPageRoute(
                                                      widget:
                                                          RegularCustomer()));
                                            },
                                            leading: Icon(
                                              Icons.report,
                                              size: 16,
                                              color: Variables.primaryColor,
                                            ),
                                            title: Text(
                                              "Add Regular Customer",
                                              style: TextStyle(
                                                  color: Variables.blackColor,
                                                  fontSize: 18,
                                                  letterSpacing: 0.3,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )))),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context, BouncyPageRoute(widget: EditScreen()));
                          },
                          leading: Icon(
                            Icons.edit,
                            size: 16,
                            color: Variables.primaryColor,
                          ),
                          title: Text(
                            "Edit Account",
                            style: TextStyle(
                                color: Variables.blackColor,
                                fontSize: 18,
                                letterSpacing: 0.3,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.push(
                                context, BouncyPageRoute(widget: BorrowScreen()));
                          },
                          leading: Icon(
                            FontAwesome.tasks,
                            size: 16,
                            color: Variables.primaryColor,
                          ),
                          title: Text(
                            "Borrow",
                            style: TextStyle(
                                color: Variables.blackColor,
                                fontSize: 18,
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
                                fontSize: 18,
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
                                fontSize: 18,
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
// FutureBuilder(
//                     future: _authMethods.getUserDetailsById(_currentUserId),
//                     builder: (context, snapshot) {
//                       User currentUser = snapshot.data;
//                       if (snapshot.hasData) {
//                         return Column(
//                           children: <Widget>[
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(20),
//                               child: CachedNetworkImage(
//                                   imageUrl: currentUser.profilePhoto),
//                             ),
//                             SizedBox(height: 10),
//                             Text(
//                               currentUser.name,
//                               style: TextStyle(
//                                 color: Variables.blackColor,
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 18,
//                                 letterSpacing: 0.7,
//                               ),
//                             ),
//                             SizedBox(height: 10),
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 7, horizontal: 15),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(50),
//                                   color: Colors.white),
//                               child: Text(
//                                 "agnelselvan007",
//                                 style: TextStyle(color: Variables.primaryColor),
//                               ),
//                             ),
//                           ],
//                         );
//                       }
//                       return CustomCircularLoading();
//                     }),
