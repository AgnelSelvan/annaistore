import 'package:annaistore/models/user.dart';
import 'package:annaistore/resources/auth_methods.dart';
import 'package:annaistore/screens/bill_screen.dart';
import 'package:annaistore/screens/custom_loading.dart';
import 'package:annaistore/screens/stock_screen.dart';
import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/bouncy_page_route.dart';
import 'package:annaistore/widgets/custom_divider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

AuthMethods _authMethods = AuthMethods();

Drawer customDrawer(BuildContext context, String currentUserId) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        drawerHeader(context, currentUserId),
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

DrawerHeader drawerHeader(BuildContext context, String currentUserId) {
  return DrawerHeader(
    decoration: BoxDecoration(
      color: Variables.greyColor,
    ),
    child: FutureBuilder(
        future: _authMethods.getUserDetailsById(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User currentUser = snapshot.data;
            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child:
                        CachedNetworkImage(imageUrl: currentUser.profilePhoto),
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
            );
          }
          return CustomCircularLoading();
        }),
  );
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
