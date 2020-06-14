
import 'package:annaistore/resources/auth_methods.dart';
import 'package:annaistore/screens/canvas_screen.dart';
import 'package:annaistore/screens/map_screen.dart';
import 'package:annaistore/screens/thread_screen.dart';
import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/bouncy_page_route.dart';
import 'package:annaistore/widgets/custom_appbar.dart';
import 'package:annaistore/widgets/custom_drawer.dart';
import 'package:annaistore/widgets/map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TabController _tabController;
  final AuthMethods _authMethods = AuthMethods();
  String currentUserId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _authMethods.getCurrentUser().then((FirebaseUser user) {
      setState(() {
        currentUserId = user.uid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        bgColor: Colors.white,
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
      drawer: customDrawer(context, currentUserId),
      body: Container(
        child: buildBody(context),
      ),
    );
  }

  ListView buildBody(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(left: 10.0),
      children: <Widget>[
        SizedBox(height: 15.0),
        Text('Categories',
            style: TextStyle(
                fontSize: 28.0,
                color: Variables.blackColor,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 15.0),
        TabBar(
            controller: _tabController,
            indicatorColor: Colors.transparent,
            labelColor: Variables.primaryColor,
            isScrollable: false,
            labelPadding: EdgeInsets.only(right: 45.0),
            unselectedLabelColor: Color(0xFFCDCDCD),
            tabs: [
              Tab(
                child: Text('Threads',
                    style: TextStyle(
                      fontSize: 18.0,
                    )),
              ),
              Tab(
                child: Text('Paper Canvas',
                    style: TextStyle(
                      fontSize: 18.0,
                    )),
              ),
              Tab(
                child: Text('Rolls',
                    style: TextStyle(
                      fontSize: 18.0,
                    )),
              )
            ]),
        Container(
            height: MediaQuery.of(context).size.height / 2.3,
            width: double.infinity,
            child: TabBarView(controller: _tabController, children: [
              ThreadScreen(),
              CanvasScreen(),
              ThreadScreen(),
            ])),
        SizedBox(height: 15.0),
        GestureDetector(
          onTap: () {
            Navigator.push(context, BouncyPageRoute(widget: MapScreen()));
          },
          child: Text('Location',
              style: TextStyle(
                  fontSize: 28.0,
                  color: Variables.blackColor,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(height: 15.0),
        Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: 300,
          child: BuildMap(),
        )
      ],
    );
  }
}
