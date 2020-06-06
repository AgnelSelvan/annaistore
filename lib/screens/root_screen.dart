import 'package:annaistore/models/user.dart';
import 'package:annaistore/resources/auth_methods.dart';
import 'package:annaistore/screens/bill_screen.dart';
import 'package:annaistore/screens/navigation_screens/home_screen.dart';
import 'package:annaistore/screens/navigation_screens/profile_screen.dart';
import 'package:annaistore/screens/stock_screen.dart';
import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/bouncy_page_route.dart';
import 'package:annaistore/widgets/custom_appbar.dart';
import 'package:annaistore/widgets/custom_divider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class RootScreen extends StatefulWidget {
  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AuthMethods _authMethods = AuthMethods();
  User currentUser;
  int _page = 0;

  final tabs = [HomeScreen(), ProfileScreen()];

  @override
  void initState() {
    super.initState();
    _authMethods.getCurrentUser().then((FirebaseUser user) {
      setState(() {
        currentUser = User(
            uid: user.uid,
            name: user.displayName,
            email: user.email,
            profilePhoto: user.photoUrl);
      });
    });
  }

  void navigationTapped(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Variables.lightGreyColor,
      body: tabs[_page],
      drawer: customDrawer(context),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.white,
          onTap: navigationTapped,
          currentIndex: _page,
          iconSize: 19,
          selectedFontSize: 20,
          unselectedFontSize: 16,
          selectedIconTheme: IconThemeData(color: Variables.primaryColor),
          unselectedIconTheme: IconThemeData(color: Colors.grey),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 19,
              ),
              title: Text(
                "Home",
                style: TextStyle(
                    fontSize: 18,
                    color: (_page == 0) ? Variables.primaryColor : Colors.grey),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
                size: 19,
              ),
              title: Text(
                "Profile",
                style: TextStyle(
                    fontSize: 18,
                    color: (_page == 1) ? Variables.primaryColor : Colors.grey),
              ),
            ),
          ]),
    );
  }

  Drawer customDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          drawerHeader(context),
          DrawerListItem(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, BouncyPageRoute(widget: StockScreen()));
            },
            icon: FontAwesome.stack_exchange,
            text: "In Stock",
          ),
          CustomDivider(leftSpacing: 20, rightSpacing: 20),
          DrawerListItem(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, BouncyPageRoute(widget: BillScreen()));
            },
            icon: FontAwesome.file_excel_o,
            text: "Billing",
          ),
          CustomDivider(leftSpacing: 20, rightSpacing: 20),
          // GestureDetector(
          //   child: ListTile(
          //     title: Text(
          //       "Dark Theme",
          //       style: Variables.drawerListTextStyle,
          //     ),
          //     leading: Icon(
          //       FontAwesome.adjust,
          //       size: 18,
          //     ),
          //     trailing: Switch(
          //       // value: darkThemeEnabled,
          //       onChanged: themeController.changeTheme,
          //     ),
          //   ),
          // ),
          // CustomDivider(leftSpacing: 20, rightSpacing: 20)
        ],
      ),
    );
  }

  DrawerHeader drawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Variables.greyColor,
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(imageUrl: currentUser.profilePhoto),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 16,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              currentUser.name,
              style: TextStyle(
                  color: Variables.primaryColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5),
            ),
          ),
          Align(
            alignment: Alignment.centerRight + Alignment(0, .3),
            child: Text(
              'Annai Store',
              style: TextStyle(color: Variables.blackColor),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerListItem extends StatelessWidget {
  final GestureTapCallback onTap;
  final String text;
  final IconData icon;
  const DrawerListItem(
      {@required this.onTap, @required this.text, @required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Icon(
          icon,
          size: 18,
        ),
        title: Text(text, style: Variables.drawerListTextStyle),
      ),
    );
  }
}
