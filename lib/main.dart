import 'dart:io';
import 'package:annaistore/constants/theme.dart';
import 'package:annaistore/resources/auth_methods.dart';
import 'package:annaistore/screens/auth_screen.dart';
import 'package:annaistore/screens/root_screen.dart';
import 'package:annaistore/theme/theme_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _setTargetPlatformForDesktop() {
  if (Platform.isLinux || Platform.isWindows) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
}

void main() {
  _setTargetPlatformForDesktop();
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences.getInstance().then((prefs) {
    var darkModeOn = prefs.getBool('darkMode') ?? true;
    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        builder: (_) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
        create: (_) => ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      theme: themeNotifier.getTheme(),
      // theme: snapshot.data ? ThemeData.dark() : ThemeData.light(),
      // theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      // themeMode: snapshot.data ? ThemeMode.dark : ThemeMode.light,
      // home: HomePage(snapshot.data)
      home: FutureBuilder(
        future: _authMethods.getCurrentUser(),
        builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            return RootScreen();
          } else {
            return AuthScreen();
          }
        },
      ),
    );
  }
}

// class HomePage extends StatelessWidget {
//   GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final bool darkThemeEnabled;

//   HomePage(this.darkThemeEnabled);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       backgroundColor: Variables.lightGreyColor,
//       appBar: CustomAppBar(
//           title: Text("Annai Store", style: Variables.appBarTextStyle),
//           actions: null,
//           leading: IconButton(
//               icon: Icon(
//                 Icons.menu,
//                 color: Variables.primaryColor,
//               ),
//               onPressed: () {
//                 _scaffoldKey.currentState.openDrawer();
//               }),
//           centerTitle: true),
//       body: Center(child: RootScreen()),
//       drawer: customDrawer(context),
//     );
//   }

//   Drawer customDrawer(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         children: <Widget>[
//           drawerHeader(context),
//           DrawerListItem(
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(context, BouncyPageRoute(widget: StockScreen()));
//             },
//             icon: FontAwesome.stack_exchange,
//             text: "In Stock",
//           ),
//           CustomDivider(leftSpacing: 20, rightSpacing: 20),
//           DrawerListItem(
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(context, BouncyPageRoute(widget: BillScreen()));
//             },
//             icon: FontAwesome.file_excel_o,
//             text: "Billing",
//           ),
//           CustomDivider(leftSpacing: 20, rightSpacing: 20),
//           GestureDetector(
//             child: ListTile(
//               title: Text(
//                 "Dark Theme",
//                 style: Variables.drawerListTextStyle,
//               ),
//               leading: Icon(
//                 FontAwesome.adjust,
//                 size: 18,
//               ),
//               trailing: Switch(
//                 value: darkThemeEnabled,
//                 onChanged: themeController.changeTheme,
//               ),
//             ),
//           ),
//           CustomDivider(leftSpacing: 20, rightSpacing: 20)
//         ],
//       ),
//     );
//   }

//   DrawerHeader drawerHeader(BuildContext context) {
//     return DrawerHeader(
//       decoration: BoxDecoration(
//         color: Variables.primaryColor,
//       ),
//       child: Stack(
//         children: <Widget>[
//           Align(
//             alignment: Alignment.centerLeft,
//             child: CircleAvatar(
//               child: Align(
//                 alignment: Alignment.bottomRight,
//                 child: Icon(Icons.check_circle,
//                     color: Theme.of(context).colorScheme.secondary),
//               ),
//               backgroundImage: AssetImage('./assets/images/admin.jpg'),
//               radius: 50.0,
//             ),
//           ),
//           Align(
//             alignment: Alignment.centerRight,
//             child: Text(
//               'Nesan',
//               style: TextStyle(
//                   color: Variables.lightGreyColor,
//                   fontSize: 28,
//                   fontWeight: FontWeight.w400,
//                   letterSpacing: 0.5),
//             ),
//           ),
//           Align(
//             alignment: Alignment.centerRight + Alignment(0, .3),
//             child: Text(
//               'Annai Store',
//               style: TextStyle(color: Variables.blackColor),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class DrawerListItem extends StatelessWidget {
//   final GestureTapCallback onTap;
//   final String text;
//   final IconData icon;
//   const DrawerListItem(
//       {@required this.onTap, @required this.text, @required this.icon});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: ListTile(
//         leading: Icon(
//           icon,
//           size: 18,
//         ),
//         title: Text(text, style: Variables.drawerListTextStyle),
//       ),
//     );
//   }
// }
