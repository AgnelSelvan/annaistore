import 'package:annaistore/models/user.dart';
import 'package:annaistore/resources/auth_methods.dart';
import 'package:annaistore/screens/admin/add/add_category.dart';
import 'package:annaistore/screens/admin/add/add_product.dart';
import 'package:annaistore/screens/admin/add/add_sub_category.dart';
import 'package:annaistore/screens/admin/add/add_unit.dart';
import 'package:annaistore/screens/admin/admin_page.dart';
import 'package:annaistore/screens/admin/bill_screen.dart';
import 'package:annaistore/screens/admin/borrow/borrow_list.dart';
import 'package:annaistore/screens/admin/history.dart';
import 'package:annaistore/screens/admin/stock/stock_screen.dart';
import 'package:annaistore/screens/admin/tax/tax_calculator.dart';
import 'package:annaistore/screens/admin/tax/tax_report.dart';
import 'package:annaistore/screens/auth_screen.dart';
import 'package:annaistore/screens/chat_screen.dart';
import 'package:annaistore/screens/custom_loading.dart';
import 'package:annaistore/screens/edit_profile_screen.dart';
import 'package:annaistore/screens/report_screen.dart';
import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/bouncy_page_route.dart';
import 'package:annaistore/widgets/custom_appbar.dart';
import 'package:annaistore/widgets/dialogs.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
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
  String currentUserId;
  bool isAdmin = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  getUserDetails() async {
    FirebaseUser firebaseUser = await _authMethods.getCurrentUser();
    setState(() {
      currentUserId = firebaseUser.uid;
    });
    User user = await _authMethods.getUserDetailsById(firebaseUser.uid);
    //print("currentUser:${user.role}");
    setState(() {
      currentUser = user;
    });
    if (user.role == 'admin') {
      setState(() {
        isAdmin = true;
      });
    }
  }

  signOut() async {
    final bool isSignOut = await _authMethods.signOut();
    if (isSignOut) {
      Navigator.pushAndRemoveUntil(
          context, BouncyPageRoute(widget: AuthScreen()), (route) => false);
    }
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
                  signOut();
                });
              })
        ],
        leading: null,
        centerTitle: true,
      ),
      backgroundColor: Colors.yellow[50],
      body: isLoading
          ? CustomCircularLoading()
          : ListView(
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
                          future:
                              _authMethods.getUserDetailsById(currentUserId),
                          builder: (context, snapshot) {
                            User currentUser = snapshot.data;
                            if (snapshot.hasData) {
                              return Column(
                                children: <Widget>[
                                  currentUser.profilePhoto == null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(120),
                                          child: Container(
                                            width: 100,
                                            child: Image.asset(
                                                'assets/images/unknown_user.jpeg'),
                                          ))
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                              imageUrl:
                                                  currentUser.profilePhoto),
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
                                      style: TextStyle(
                                          color: Variables.primaryColor),
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
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(50))),
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: <Widget>[
                              FutureBuilder(
                                future: _authMethods
                                    .getUserDetailsById(currentUserId),
                                builder:
                                    (context, AsyncSnapshot<User> snapshot) {
                                  if (snapshot.hasData) {
                                    User currentUser = snapshot.data;
                                    //print(currentUser.role);
                                    return currentUser.role == 'admin'
                                        ? ExpandableTheme(
                                            data: const ExpandableThemeData(
                                              iconColor: Colors.yellow,
                                              useInkWell: true,
                                            ),
                                            child: ExpandableNotifier(
                                                child: ScrollOnExpand(
                                                    scrollOnExpand: true,
                                                    scrollOnCollapse: false,
                                                    child: ExpandablePanel(
                                                      theme:
                                                          const ExpandableThemeData(
                                                        headerAlignment:
                                                            ExpandablePanelHeaderAlignment
                                                                .center,
                                                        tapBodyToCollapse: true,
                                                      ),
                                                      header: Padding(
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: ListTile(
                                                          leading: Icon(
                                                            Icons.add,
                                                            size: 16,
                                                            color: Variables
                                                                .primaryColor,
                                                          ),
                                                          title: Text(
                                                            'Add',
                                                            style: TextStyle(
                                                                color: Variables
                                                                    .blackColor,
                                                                fontSize: 16,
                                                                letterSpacing:
                                                                    0.3,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ),
                                                      ),
                                                      expanded: Column(
                                                        children: <Widget>[
                                                          CustomTile(
                                                            text: "Add Stock",
                                                            icon: FontAwesome
                                                                .stack_overflow,
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  BouncyPageRoute(
                                                                      widget:
                                                                          StockScreen()));
                                                            },
                                                          ),
                                                          CustomTile(
                                                            text:
                                                                "Add Category",
                                                            icon: FontAwesome
                                                                .list_alt,
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  BouncyPageRoute(
                                                                      widget:
                                                                          AddCategory()));
                                                            },
                                                          ),
                                                          CustomTile(
                                                            text:
                                                                "Add Sub-Category",
                                                            icon: FontAwesome
                                                                .list_alt,
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  BouncyPageRoute(
                                                                      widget:
                                                                          AddSubCategory()));
                                                            },
                                                          ),
                                                          CustomTile(
                                                            text: "Add Product",
                                                            icon: FontAwesome
                                                                .product_hunt,
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  BouncyPageRoute(
                                                                      widget:
                                                                          AddProduct()));
                                                            },
                                                          ),
                                                          CustomTile(
                                                            text: "Add Unit",
                                                            icon: Icons.ac_unit,
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  BouncyPageRoute(
                                                                      widget:
                                                                          AddUnit()));
                                                            },
                                                          ),
                                                          CustomTile(
                                                            text:
                                                                "Add Regular Customer",
                                                            icon: Icons.report,
                                                            onTap: () {},
                                                          )
                                                        ],
                                                      ),
                                                    ))))
                                        : Container();
                                  }
                                  return CustomCircularLoading();
                                },
                              ),
                              isAdmin
                                  ? CustomTile(
                                      text: "Make Admin",
                                      icon: FontAwesome.user_circle_o,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            BouncyPageRoute(
                                                widget: MakeAdminScreen()));
                                      },
                                    )
                                  : Container(),
                              isAdmin
                                  ? CustomTile(
                                      text: "Billing",
                                      icon: FontAwesome.money,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            BouncyPageRoute(
                                                widget: BillScreen()));
                                      },
                                    )
                                  : Container(),
                              CustomTile(
                                text: "Borrow",
                                icon: Icons.edit,
                                onTap: () {
                                  Navigator.push(context,
                                      BouncyPageRoute(widget: BorrowList()));
                                },
                              ),
                              isAdmin
                                  ? CustomTile(
                                      text: "Tax Report",
                                      icon: FontAwesome.hand_paper_o,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            BouncyPageRoute(
                                                widget: TaxReport()));
                                      },
                                    )
                                  : Container(),
                              isAdmin
                                  ? CustomTile(
                                      text: "History",
                                      icon: FontAwesome.history,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            BouncyPageRoute(
                                                widget: HistoryScreen()));
                                      },
                                    )
                                  : Container(),
                              CustomTile(
                                text: "Tax Calculator",
                                icon: FontAwesome.calculator,
                                onTap: () {
                                  Navigator.push(context,
                                      BouncyPageRoute(widget: TaxCalculator()));
                                },
                              ),
                              CustomTile(
                                text: "Edit Account",
                                icon: Icons.edit,
                                onTap: () {
                                  Navigator.push(context,
                                      BouncyPageRoute(widget: EditScreen()));
                                },
                              ),
                              isAdmin
                                  ? CustomTile(
                                      text: "Reports",
                                      icon: Icons.report,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            BouncyPageRoute(
                                                widget: ReportScreen()));
                                      },
                                    )
                                  : Container(),
                              CustomTile(
                                text: "Give your suggestion",
                                icon: Icons.chat,
                                onTap: () {
                                  Navigator.push(context,
                                      BouncyPageRoute(widget: ChatScreen()));
                                },
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

class CustomTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final GestureTapCallback onTap;

  const CustomTile({@required this.text, @required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        size: 16,
        color: Variables.primaryColor,
      ),
      title: Text(
        text,
        style: TextStyle(
            color: Variables.blackColor,
            fontSize: 16,
            letterSpacing: 0.3,
            fontWeight: FontWeight.w400),
      ),
    );
  }
}
