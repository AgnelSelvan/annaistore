import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/custom_appbar.dart';
import 'package:annaistore/widgets/header.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class StockScreen extends StatefulWidget {
  StockScreen({Key key}) : super(key: key);

  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Variables.lightGreyColor,
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
      body: ExpandableTheme(
        data: const ExpandableThemeData(
          // iconColor: Variables.primaryColor,
          useInkWell: true,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            SizedBox(height: 15.0),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: BuildHeader(text: "ITEMS IN STOCK")
            ),
            Card1(),
            Card2(),
            Card2(),
          ],
        ),
      ),
    );

    // return Center(
    //   child: Container(
    //       width: MediaQuery.of(context).size.width * 0.9,
    //       child: ListView(
    //         children: <Widget>[

    //           ExpansionTile(
    //             leading: Image.asset(
    //               'assets/Icons/vardhaman-thread.png',
    //               width: 25,
    //               height: 25,
    //             ),
    //             title: Padding(
    //               padding: const EdgeInsets.all(4.0),
    //               child: Text(
    //                 "Vardhaman Threads",
    //                 style: Theme.of(context).textTheme.title,
    //               ),
    //             ),
    //             children: <Widget>[
    //               Container(
    //                 child: ExpansionTile(
    //                   title: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceAround,
    //                     children: <Widget>[
    //                       Row(
    //                         children: <Widget>[
    //                           Icon(FontAwesome.stack_overflow),
    //                           Text("Boxs", style: Theme.of(context).textTheme.subtitle,),
    //                         ],
    //                       ),
    //                       Text("100", style: Theme.of(context).textTheme.subtitle,)
    //                     ],
    //                   ),
    //                   children: <Widget>[
    //                     SizedBox(
    //                       width: MediaQuery.of(context).size.width * 0.5,
    //                       child: ListTile(
    //                         title: Text('No.', style: Theme.of(context).textTheme.subtitle,),
    //                         trailing: Text("Qty", style: Theme.of(context).textTheme.subtitle,),
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       width: MediaQuery.of(context).size.width * 0.5,
    //                       child: ListTile(
    //                         title: Text('1', style: Theme.of(context).textTheme.subtitle,),
    //                         trailing: Text("50", style: Theme.of(context).textTheme.subtitle,),
    //                       ),
    //                     ),
    //                     SizedBox(
    //                       width: MediaQuery.of(context).size.width * 0.5,
    //                       child: ListTile(
    //                         title: Text('2', style: Theme.of(context).textTheme.subtitle,),
    //                         trailing: Text("50", style: Theme.of(context).textTheme.subtitle,),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               )
    //             ],
    //           ),

    //           ExpansionTile(
    //             leading: Image.asset(
    //               'assets/Icons/vardhaman-thread.png',
    //               width: 25,
    //               height: 25,
    //             ),
    //             title: Padding(
    //               padding: const EdgeInsets.all(4.0),
    //               child: Text(
    //                 "Canvas",
    //                 style: Theme.of(context).textTheme.title,
    //               ),
    //             ),
    //             children: <Widget>[
    //               SizedBox(
    //                 width: MediaQuery.of(context).size.width * 0.5,
    //                 child: ListTile(
    //                   title: Text('Inch', style: Theme.of(context).textTheme.subtitle,),
    //                   trailing: Text("Qty", style: Theme.of(context).textTheme.subtitle,),
    //                 ),
    //               ),
    //               SizedBox(
    //                 width: MediaQuery.of(context).size.width * 0.5,
    //                 child: ListTile(
    //                   title: Text("1''", style: Theme.of(context).textTheme.subtitle,),
    //                   trailing: Text("10", style: Theme.of(context).textTheme.subtitle,),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ],
    //       )),
    // );
  }
}

class Card1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  color: Variables.primaryColor,
                  shape: BoxShape.rectangle,
                ),
                child: Image.asset('assets/images/vardham-thread.jpg'),
              ),
            ),
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Vardhaman Thread",
                      style: Theme.of(context).textTheme.title,
                    )),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ExpandableNotifier(
                        child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Card(
                                elevation: 0,
                                clipBehavior: Clip.antiAlias,
                                child: Column(children: <Widget>[
                                  ScrollOnExpand(
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
                                              child: Text(
                                                "Boxes(100)",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle,
                                              )),
                                          expanded: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Text(
                                                      "No.",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle,
                                                    ),
                                                    Text(
                                                      "Qty",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Text(
                                                      "1",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle,
                                                    ),
                                                    Text(
                                                      "20",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle,
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Text(
                                                      "2",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle,
                                                    ),
                                                    Text(
                                                      "30",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle,
                                                    ),
                                                  ],
                                                )
                                              ])))
                                ]))))
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            
            ),
          ],
        ),
      ),
    ));
  }
}

class Card2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.rectangle,
                ),
                child: Image.asset('assets/images/paper-canvas.jpg'),
              ),
            ),
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Canvas",
                          style: Theme.of(context).textTheme.title,
                        ),
                      ],
                    )),
                expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          "Inch",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        Text(
                          "Qty",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          "1''",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        Text(
                          "20",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          "2''",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                        Text(
                          "30",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ],
                    )
                  ],
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
