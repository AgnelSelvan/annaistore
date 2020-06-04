import 'dart:async';

import 'package:annaistore/screens/bill_screen.dart';
import 'package:annaistore/screens/home_screen.dart';
import 'package:annaistore/screens/stock_screen.dart';
import 'package:annaistore/theme/app_theme.dart';
import 'package:annaistore/theme/theme_controller.dart';
import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/bouncy_page_route.dart';
import 'package:annaistore/widgets/custom_appbar.dart';
import 'package:annaistore/widgets/custom_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: themeController.darkThemeEnabled,
      initialData: false,
      builder: (context, snapshot) => MaterialApp(
          // theme: snapshot.data ? ThemeData.dark() : ThemeData.light(),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: snapshot.data ? ThemeMode.dark : ThemeMode.light,
          home: HomePage(snapshot.data)),
    );
  }
}

class HomePage extends StatelessWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final bool darkThemeEnabled;

  HomePage(this.darkThemeEnabled);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Variables.lightGreyColor,
      appBar: CustomAppBar(
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
          centerTitle: null),
      body: Center(child: HomeScreen()),
      drawer: customDrawer(context),
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
          GestureDetector(
            child: ListTile(
              title: Text(
                "Dark Theme",
                style: Variables.drawerListTextStyle,
              ),
              leading: Icon(
                FontAwesome.adjust,
                size: 18,
              ),
              trailing: Switch(
                value: darkThemeEnabled,
                onChanged: themeController.changeTheme,
              ),
            ),
          ),
          CustomDivider(leftSpacing: 20, rightSpacing: 20)
        ],
      ),
    );
  }

  DrawerHeader drawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Variables.primaryColor,
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: CircleAvatar(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.check_circle,
                    color: Theme.of(context).colorScheme.secondary),
              ),
              backgroundImage: AssetImage('./assets/images/admin.jpg'),
              radius: 50.0,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Nesan',
              style: TextStyle(
                  color: Variables.lightGreyColor,
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
