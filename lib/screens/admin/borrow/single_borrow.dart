import 'dart:io';
import 'dart:typed_data';
import 'package:annaistore/models/bill.dart';
import 'package:annaistore/models/borrow.dart';
import 'package:annaistore/models/borrow_model.dart';
import 'package:annaistore/models/product.dart';
import 'package:annaistore/models/user.dart';
import 'package:annaistore/resources/admin_methods.dart';
import 'package:annaistore/resources/auth_methods.dart';
import 'package:annaistore/screens/admin/borrow/pdf_viewer.dart';
import 'package:annaistore/screens/custom_loading.dart';
import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/utils/utilities.dart';
import 'package:annaistore/widgets/bouncy_page_route.dart';
import 'package:annaistore/widgets/custom_appbar.dart';
import 'package:annaistore/widgets/custom_divider.dart';
import 'package:annaistore/widgets/dialogs.dart';
import 'package:annaistore/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words_spelling/number_to_words_spelling.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:save_in_gallery/save_in_gallery.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pdf/pdf.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as I;
import 'package:esys_flutter_share/esys_flutter_share.dart';

AdminMethods _adminMethods = AdminMethods();
AuthMethods _authMethods = AuthMethods();

class SingleBorrow extends StatefulWidget {
  final String borrowId;
  SingleBorrow({@required this.borrowId});

  @override
  _SingleBorrowState createState() => _SingleBorrowState();
}

class _SingleBorrowState extends State<SingleBorrow> {
  TextEditingController _buyerInfoController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _containerKey = GlobalKey();
  User currentUser;
  final _imageSaver = ImageSaver();
  // VoidCallback
  Bill bill;
  bool isLoading = false;
  final pdf = pw.Document();

  List<List<dynamic>> datas = List();
  List<Bill> docList = List();
  double amount = 0;
  double grossAmount = 0;
  double totalSGST = 0;
  double totalCGST = 0;
  String amounten;
  var amountToBeGiven = 0;

  getBorrowById() async {
    setState(() {
      isLoading = true;
    });
    Borrow borrow = await _adminMethods.getBorrowById(widget.borrowId);
    Bill _bill = await _adminMethods.getBillById(borrow.billId);
    setState(() {
      bill = _bill;
      isLoading = false;
      amountToBeGiven = amountToBeGiven + (_bill.price - _bill.givenAmount);
    });

    for (dynamic i = 0; i < bill.productList.length; i++) {
      List<dynamic> data = List();
      Product product = await _adminMethods
          .getProductDetailsFromProductId(bill.productListId[i]);
      data.add(bill.productList[i]);
      data.add(product.hsnCode);
      data.add(bill.taxList[i]);
      data.add(bill.qtyList[i]);
      data.add(bill.sellingRateList[i]);
      amount = amount +
          ((bill.qtyList[i] * bill.sellingRateList[i]) +
              ((bill.qtyList[i] * bill.sellingRateList[i]) *
                  (bill.taxList[i] / 100)));
      grossAmount = grossAmount + (bill.qtyList[i] * bill.sellingRateList[i]);
      totalSGST = totalSGST +
          (((bill.qtyList[i] * bill.sellingRateList[i]) *
                  (bill.taxList[i] / 100)) /
              2);
      totalCGST = totalCGST +
          (((bill.qtyList[i] * bill.sellingRateList[i]) *
                  (bill.taxList[i] / 100)) /
              2);
      datas.add(data);
      print("totalSGST:$totalSGST");
    }
    setState(() {
      amounten = NumberWordsSpelling.toWord(amount.toStringAsFixed(0), 'en_US');
    });
  }

  getCurrentUser() async {
    setState(() {
      isLoading = true;
    });
    FirebaseUser user = await _authMethods.getCurrentUser();
    if (user == null) {
      // Dialogs.okDialog(
      //     context, 'Error', 'Check your internet connection', Colors.red[200]);
    } else {
      User nowUser = await _authMethods.getUserDetailsById(user.uid);
      setState(() {
        currentUser = nowUser;
        isLoading = false;
      });
    }
    print(currentUser.mobileNo);
  }

  convertWidgetToImage() async {
    setState(() {
      isLoading = true;
    });
    RenderRepaintBoundary renderRepaintBoundary =
        _containerKey.currentContext.findRenderObject();
    ui.Image boxImage = await renderRepaintBoundary.toImage(pixelRatio: 1);
    ByteData byteData =
        await boxImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List png = byteData.buffer.asUint8List();
    List<Uint8List> pngList = [];
    final dir = await getExternalStorageDirectory();
    pngList.add(png);
    final res = await _imageSaver.saveImages(
        imageBytes: pngList, directoryName: '${dir.path}/image.jpg');
    print(res.toString());

    print(dir.path);

    final file = await new File('${dir.path}/sample.png').create();
    file.writeAsBytesSync(png);
    print(file);

    String text =
        'Dear sir/madam, your payment of ₹ ${(bill.price - bill.givenAmount).toString()} is still pending. Make payment as soon as possible';
    try {
      await Share.file('esys image', 'sample.png', png, 'image/png',
          text: text);
    } catch (e) {
      Dialogs.okDialog(
          context, 'Error', 'Error launching whatsapp', Colors.red[200]);
    }

    // String text =
    //     'Dear sir/madam, your payment of ₹ ${(borrowModel.price - borrowModel.givenAmount).toString()} is still pending. Make payment as soon as possible';
    // print("Hii");
    // var uri =
    //     "whatsapp://send?phone=${borrowModel.mobileNo}&text=$text&img=${file.path}";
    // if (await canLaunch(uri)) {
    //   await launch(uri);
    // } else {
    //   Dialogs.okDialog(
    //       context, 'Error', 'Error launching whatsapp', Colors.red[200]);
    // }
    setState(() {
      isLoading = false;
    });
  }

  getListOfBorrow() async {
    List<DocumentSnapshot> docs =
        await _adminMethods.getListOfBorrow(widget.borrowId);
    for (var doc in docs) {
      Bill bill = await _adminMethods.getBillById(doc.data['bill_id']);
      setState(() {
        docList.add(bill);
      });

      setState(() {
        amountToBeGiven = amountToBeGiven + (bill.price - bill.givenAmount);
      });
    }
    print(amountToBeGiven);
  }

  @override
  void initState() {
    super.initState();
    getBorrowById();
    getCurrentUser();
    getListOfBorrow();
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
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StickyHeader(
                        header: buildStickyHeaderListView(context),
                        content: buildStickyBody(),
                      ),
                    ],
                  ),
                ),
              ));
  }

  buildStickyBody() {
    return ListView(
      shrinkWrap: true,
      children: [buildBodyHeadButtons(), buildEntries()],
    );
  }

  buildEntries() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "Bill No",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: .5),
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: 25,
                alignment: Alignment.center,
                child: Text(
                  bill.billNo == null ? 'Error Loading...' : bill.billNo,
                  style: TextStyle(
                      color: Variables.blackColor,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.3),
                ),
              ),
              SizedBox(height: 5),
              Column(
                  children: List.generate(docList.length, (index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FocusedMenuHolder(
                      blurSize: 2,
                      menuItems: <FocusedMenuItem>[
                        FocusedMenuItem(
                            title: Text("Report"),
                            onPressed: () {
                              if (bill.isTax == null) {
                                Dialogs.okDialog(context, 'Error',
                                    'Somthing went wrong!', Colors.red[200]);
                              } else {
                                bill.isTax ? getBuyerName() : getKachaBill();
                              }
                            },
                            trailingIcon: Icon(
                              FontAwesome.file_pdf_o,
                              color: Colors.red[200],
                            )),
                        FocusedMenuItem(
                            title: Text("Whatsapp"),
                            onPressed: () {
                              _showModalSheet();
                            },
                            trailingIcon: Icon(
                              FontAwesome.whatsapp,
                              color: Colors.green[200],
                            )),
                        FocusedMenuItem(
                            title: Text("SMS"),
                            onPressed: () async {
                              var uri =
                                  'sms:${bill.mobileNo}?body=Dear sir/madam, your payment of ₹ ${(bill.price - bill.givenAmount).toString()} is still pending. Make payment as soon as possible';
                              if (await canLaunch(uri)) {
                                await launch(uri);
                              } else {
                                Dialogs.okDialog(
                                    context,
                                    'Error',
                                    'Error launching whatsapp',
                                    Colors.red[200]);
                              }
                            },
                            trailingIcon: Icon(
                              Icons.sms,
                              color: Colors.blue[200],
                            ))
                      ],
                      onPressed: () {},
                      child: Container(
                        height: 25,
                        alignment: Alignment.center,
                        child: Text(
                          docList[index].billNo.toString(),
                          style: TextStyle(
                              color: Variables.blackColor,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.3),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                );
              }))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "Date",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: .5),
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: 25,
                alignment: Alignment.center,
                child: Text(
                  DateFormat('dd/MM/yyyy').format(bill.timestamp.toDate()),
                  style: TextStyle(
                      color: Variables.blackColor,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.3),
                ),
              ),
              SizedBox(height: 5),
              Column(
                  children: List.generate(docList.length, (index) {
                return Container(
                  height: 25,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('dd/MM/yyyy')
                            .format(docList[index].timestamp.toDate()),
                        style: TextStyle(
                            color: Variables.blackColor,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.3),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                );
              }))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "Price",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: .5),
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: 25,
                alignment: Alignment.center,
                child: Text(
                  "₹${bill.price.toString()}",
                  style: TextStyle(
                      color: Variables.blackColor,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.3),
                ),
              ),
              SizedBox(height: 5),
              Column(
                  children: List.generate(docList.length, (index) {
                return Column(
                  children: [
                    Container(
                      height: 25,
                      alignment: Alignment.center,
                      child: Text(
                        '₹${docList[index].price.toString()}',
                        style: TextStyle(
                            color: Variables.blackColor,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.3),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                );
              }))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "You Got",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: .5),
                ),
              ),
              SizedBox(height: 15),
              Container(
                height: 25,
                alignment: Alignment.center,
                child: Text(
                  "₹${bill.givenAmount.toString()}",
                  style: TextStyle(
                      color: Variables.blackColor,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.3),
                ),
              ),
              SizedBox(height: 5),
              Column(
                  children: List.generate(docList.length, (index) {
                return Column(
                  children: [
                    Container(
                      height: 25,
                      alignment: Alignment.center,
                      child: Text(
                        '₹${docList[index].givenAmount.toString()}',
                        style: TextStyle(
                            color: Variables.blackColor,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.3),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                );
              }))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "Ttl Price",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: .5),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 25,
                alignment: Alignment.center,
                child: Text(
                  "₹${(bill.price - bill.givenAmount).toString()}",
                  style: TextStyle(
                      color: Variables.blackColor,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.3),
                ),
              ),
              SizedBox(height: 5),
              Column(
                  children: List.generate(docList.length, (index) {
                return Column(
                  children: [
                    Container(
                      height: 25,
                      alignment: Alignment.center,
                      child: Text(
                        '₹${(docList[index].price - docList[index].givenAmount).toString()}',
                        style: TextStyle(
                            color: Variables.blackColor,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.3),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                );
              }))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "Paid",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: .5),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 25,
                alignment: Alignment.center,
                child: Text(
                  bill.isPaid ? 'Yes' : 'No',
                  style: TextStyle(
                      color: Variables.blackColor,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0.3),
                ),
              ),
              SizedBox(height: 5),
              Column(
                  children: List.generate(docList.length, (index) {
                return Column(
                  children: [
                    Container(
                      height: 25,
                      alignment: Alignment.center,
                      child: Text(
                        docList[index].isPaid ? 'Yes' : 'No',
                        style: TextStyle(
                            color: Variables.blackColor,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.3),
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                );
              }))
            ],
          )
        ],
      ),
    );
  }

  getBuyerName() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text('Buyer Info'),
            content: Container(
              height: MediaQuery.of(context).size.height / 5,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Text(
                    "Info",
                    style: Variables.inputLabelTextStyle,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.yellow[100],
                        borderRadius: BorderRadius.circular(8)),
                    child: TextFormField(
                      maxLines: 5,
                      cursorColor: Variables.primaryColor,
                      style: Variables.inputTextStyle,
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: 'Buyer Info'),
                      controller: _buyerInfoController,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(DialogAction.Abort);
                },
                child: Text(
                  "No",
                  style: TextStyle(color: Variables.primaryColor),
                ),
              ),
              RaisedButton(
                elevation: 0,
                color: Variables.primaryColor,
                onPressed: () async {
                  Navigator.pop(context);

                  print(datas);
                  generatePakkaBillPdfAndView(context);
                },
                child: Text(
                  "Yes",
                  style: TextStyle(color: Variables.lightGreyColor),
                ),
              )
            ],
          );
        });
  }

  generatePakkaBillPdfAndView(context) async {
    if (await Permission.storage.request().isGranted) {
      try {
        //   pdf.addPage(pw.MultiPage(
        //     pageFormat: PdfPageFormat.a4,
        //     margin: pw.EdgeInsets.all(24),
        //     build: (pw.Context context) {
        //       return <pw.Widget>[
        //         pw.Container(
        //             height: PdfPageFormat.a4.height / 1.1,
        //             width: PdfPageFormat.a4.width,
        //             child: pw.Column(
        //                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        //                 crossAxisAlignment: pw.CrossAxisAlignment.center,
        //                 children: [
        //                   pw.Column(children: [
        //                     pw.Container(
        //                         child: pw.Container(
        //                             alignment: pw.Alignment.center,
        //                             child: pw.Text("Tax Invoice",
        //                                 style: pw.TextStyle(
        //                                   fontSize: 12,
        //                                 )))),
        //                     pw.SizedBox(height: 10),
        //                     pw.Row(
        //                         mainAxisAlignment:
        //                             pw.MainAxisAlignment.spaceBetween,
        //                         children: [
        //                           pw.Text('GSTIN:33AHIPC1946Q1Z4'),
        //                           pw.Column(children: [
        //                             pw.Text('Mobile :9488327699'),
        //                             pw.Text('Email :annai.charlinf@gmail.com'),
        //                           ])
        //                         ]),
        //                     pw.SizedBox(height: 5),
        //                     pw.Container(
        //                         child: pw.Container(
        //                             alignment: pw.Alignment.center,
        //                             child: pw.Text("Annai Store",
        //                                 style: pw.TextStyle(
        //                                     fontSize: 28,
        //                                     fontWeight: pw.FontWeight.bold,
        //                                     fontStyle: pw.FontStyle.italic)))),
        //                     pw.SizedBox(height: 5),
        //                     pw.Paragraph(
        //                         text:
        //                             "No.1 Yadhavar Middle Street\n Valliioor-627117",
        //                         textAlign: pw.TextAlign.center,
        //                         style: pw.TextStyle(
        //                             fontWeight: pw.FontWeight.normal,
        //                             letterSpacing: 1)),
        //                     pw.SizedBox(height: 10),
        //                     pw.Container(
        //                       height: 70,
        //                       child: pw.Row(
        //                           mainAxisAlignment:
        //                               pw.MainAxisAlignment.spaceBetween,
        //                           children: [
        //                             pw.Column(
        //                                 mainAxisAlignment:
        //                                     pw.MainAxisAlignment.spaceBetween,
        //                                 crossAxisAlignment:
        //                                     pw.CrossAxisAlignment.start,
        //                                 children: [
        //                                   pw.Column(children: [
        //                                     pw.Text('Buyer:'),
        //                                     pw.Text(
        //                                         "${_buyerInfoController.text}"),
        //                                   ]),
        //                                   pw.Column(
        //                                       crossAxisAlignment:
        //                                           pw.CrossAxisAlignment.start,
        //                                       children: [
        //                                         pw.Text('GSTIN:33AHIPC1946Q1Z4'),
        //                                         pw.Text(
        //                                             "Mobile No:${borrowModel.mobileNo}"),
        //                                       ])
        //                                 ]),
        //                             pw.Column(
        //                                 mainAxisAlignment:
        //                                     pw.MainAxisAlignment.spaceBetween,
        //                                 children: [
        //                                   pw.Text(
        //                                       'Bill No:  ${borrowModel.billNo}'),
        //                                   pw.Text(
        //                                       'Date:${DateFormat("dd/MM/yyyy").format(borrowModel.timestamp.toDate())}'),
        //                                 ]),
        //                           ]),
        //                     ),
        //                     pw.SizedBox(height: 8),
        //                     pw.Table.fromTextArray(
        //                         border: pw.TableBorder(
        //                           width: 1,
        //                         ),
        //                         context: context,
        //                         data: <List<dynamic>>[
        //                           <dynamic>[
        //                             'Product',
        //                             'HSN',
        //                             'GST',
        //                             'Qty',
        //                             'Rate',
        //                             'Amount',
        //                             'SGST',
        //                             'CGST',
        //                             'Total'
        //                           ],
        //                           ...datas.map((e) => [
        //                                 e[0],
        //                                 e[1],
        //                                 '${e[2]}',
        //                                 e[3],
        //                                 e[4],
        //                                 '${e[3] * e[4]}',
        //                                 '${(e[3] * e[4]) * (e[2] / 100)}',
        //                                 '${(e[3] * e[4]) * (e[2] / 100)}',
        //                                 '${(e[3] * e[4]) + 2 * ((e[3] * e[4]) * (e[2] / 100))}'
        //                               ])
        //                         ]),
        //                     pw.Row(
        //                         mainAxisAlignment:
        //                             pw.MainAxisAlignment.spaceBetween,
        //                         children: [
        //                           pw.Text(
        //                               'Total Items: ${borrowModel.productList.length}',
        //                               textAlign: pw.TextAlign.left),
        //                         ]),
        //                     pw.SizedBox(height: 40),
        //                   ]),
        //                   pw.Container(
        //                       child: pw.Column(
        //                           mainAxisAlignment:
        //                               pw.MainAxisAlignment.spaceAround,
        //                           children: [
        //                         pw.Row(
        //                             mainAxisAlignment:
        //                                 pw.MainAxisAlignment.spaceBetween,
        //                             children: [
        //                               pw.Row(
        //                                   mainAxisAlignment:
        //                                       pw.MainAxisAlignment.spaceBetween,
        //                                   children: [
        //                                     pw.Text(
        //                                       "Rupees:",
        //                                       style: pw.TextStyle(
        //                                           fontWeight: pw.FontWeight.bold),
        //                                     ),
        //                                     pw.Text(
        //                                       amounten.toString(),
        //                                     )
        //                                   ]),
        //                               pw.Column(
        //                                   mainAxisAlignment:
        //                                       pw.MainAxisAlignment.start,
        //                                   crossAxisAlignment:
        //                                       pw.CrossAxisAlignment.start,
        //                                   children: [
        //                                     pw.Row(
        //                                         mainAxisAlignment: pw
        //                                             .MainAxisAlignment
        //                                             .spaceBetween,
        //                                         children: [
        //                                           pw.Text(
        //                                             "Gross Amount:",
        //                                             style: pw.TextStyle(
        //                                                 fontWeight:
        //                                                     pw.FontWeight.bold),
        //                                           ),
        //                                           pw.Text(
        //                                             grossAmount.toString(),
        //                                           )
        //                                         ]),
        //                                     pw.Row(
        //                                         mainAxisAlignment: pw
        //                                             .MainAxisAlignment
        //                                             .spaceBetween,
        //                                         children: [
        //                                           pw.Text(
        //                                             "Add SGST:",
        //                                             style: pw.TextStyle(
        //                                                 fontWeight:
        //                                                     pw.FontWeight.bold),
        //                                           ),
        //                                           pw.Text(
        //                                             totalSGST.toString(),
        //                                           )
        //                                         ]),
        //                                     pw.Row(
        //                                         mainAxisAlignment: pw
        //                                             .MainAxisAlignment
        //                                             .spaceBetween,
        //                                         children: [
        //                                           pw.Text(
        //                                             "Add CGST:",
        //                                             style: pw.TextStyle(
        //                                                 fontWeight:
        //                                                     pw.FontWeight.bold),
        //                                           ),
        //                                           pw.Text(
        //                                             totalCGST.toString(),
        //                                           )
        //                                         ]),
        //                                   ])
        //                             ]),
        //                         pw.Row(
        //                             mainAxisAlignment:
        //                                 pw.MainAxisAlignment.spaceBetween,
        //                             children: [
        //                               pw.Text('Note',
        //                                   style: pw.TextStyle(
        //                                       fontWeight: pw.FontWeight.bold),
        //                                   textAlign: pw.TextAlign.left),
        //                               pw.Column(children: [
        //                                 pw.Row(
        //                                     mainAxisAlignment:
        //                                         pw.MainAxisAlignment.spaceBetween,
        //                                     children: [
        //                                       pw.Text(
        //                                         "Total Amount:",
        //                                         style: pw.TextStyle(
        //                                             fontWeight:
        //                                                 pw.FontWeight.bold),
        //                                       ),
        //                                       pw.Text(
        //                                         amount.toString(),
        //                                       )
        //                                     ]),
        //                               ])
        //                             ]),
        //                         pw.SizedBox(height: 20),
        //                         pw.Row(
        //                             mainAxisAlignment:
        //                                 pw.MainAxisAlignment.spaceBetween,
        //                             children: [
        //                               pw.Column(
        //                                   mainAxisAlignment:
        //                                       pw.MainAxisAlignment.start,
        //                                   crossAxisAlignment:
        //                                       pw.CrossAxisAlignment.start,
        //                                   children: [
        //                                     pw.Text(
        //                                       'VITY UNION BANK',
        //                                     ),
        //                                     pw.Text(
        //                                       'A/C No: 510909010138545',
        //                                     ),
        //                                     pw.Text(
        //                                       'IFSC No: CIUB0000656',
        //                                     ),
        //                                     pw.Text('Branch: Vallioor',
        //                                         textAlign: pw.TextAlign.left),
        //                                   ]),
        //                               pw.Column(children: [
        //                                 pw.Text('Annai Store',
        //                                     style: pw.TextStyle(
        //                                         fontWeight: pw.FontWeight.bold),
        //                                     textAlign: pw.TextAlign.left),
        //                                 pw.SizedBox(height: 50),
        //                                 pw.Text('Authorised Signature',
        //                                     textAlign: pw.TextAlign.left),
        //                               ])
        //                             ]),
        //                       ]))
        //                 ]))
        //       ];
        //     },
        //   ));

        //   Directory documentDirectory = await getApplicationDocumentsDirectory();

        //   String documentPath = documentDirectory.path;

        //   File file = File("$documentPath/example.pdf");
        //   try {
        //     file.writeAsBytesSync(pdf.save());
        //   } catch (e) {
        //     Dialogs.okDialog(context, 'Error',
        //         'Avoid Next line in buyer Text Field', Colors.red[200]);
        //     print(e);
        //   }
        String fullPath = await Utils.generatePakkaBill(
            bill,
            _buyerInfoController.text,
            datas,
            grossAmount,
            totalSGST,
            totalCGST,
            amounten,
            amount);
        if (fullPath == 'textfieldError') {
          Dialogs.okDialog(context, 'Error',
              'Dont use next line in buyer info textfield', Colors.red[200]);
        } else {
          Navigator.push(
              context,
              BouncyPageRoute(
                  widget: PdfPreviewwScreen(
                path: fullPath,
              )));
        }
      } catch (e) {
        Dialogs.okDialog(
            context, 'Error', 'Something went wrong!', Colors.red[200]);
      }
    } else {
      Dialogs.okDialog(
          context, 'Error', 'You have denied your permission', Colors.red[200]);
    }

    setState(() {
      _buyerInfoController.clear();
    });
  }

  void _showModalSheet() {
    showModalBottomSheet(
        backgroundColor: Colors.grey[200],
        context: context,
        builder: (builder) {
          return Container(
            padding: EdgeInsets.all(10),
            height: 300,
            child: ListView(
              children: [
                RepaintBoundary(
                  key: _containerKey,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "Payment reminder for ",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        ),
                        Text("₹${amountToBeGiven.toString()}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                        Text(
                            DateFormat('dd/MM/yyyy')
                                .format(bill.timestamp.toDate()),
                            style: TextStyle(
                                color: Variables.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.5)),
                        Text(
                            "Sent by ${currentUser.name == '' ? '' : currentUser.name}",
                            style: TextStyle(
                                color: Variables.blackColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w300)),
                        Text(
                            "${currentUser.mobileNo == null ? '' : currentUser.mobileNo}"),
                      ],
                    ),
                  ),
                ),
                buildRaisedButton(
                    'Send Reminder', Variables.primaryColor, Colors.white, () {
                  convertWidgetToImage();
                })
              ],
            ),
          );
        });
  }

  getKachaBill() async {
    File file = await Utils.generateKachaBill(bill);
    if (file == null) {
      Dialogs.okDialog(
          context, 'Error', "Somthing went wrong!", Colors.red[200]);
    } else {
      String fullPath = file.path;
      print('Utils working');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PdfPreviewwScreen(
                    path: fullPath,
                  )));
    }
  }

  buildBodyHeadButtons() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () async {
              print(bill.billNo);
              if (bill.isTax == null) {
                Dialogs.okDialog(
                    context, 'Error', 'Somthing went wrong!', Colors.red[200]);
              } else {
                bill.isTax ? getBuyerName() : getKachaBill();
              }
            },
            child: Column(
              children: [
                Icon(
                  FontAwesome.file_pdf_o,
                  color: Colors.red[200],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Report",
                  style: TextStyle(
                      color: Variables.blackColor,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _showModalSheet();
            },
            child: Column(
              children: [
                Icon(
                  FontAwesome.whatsapp,
                  color: Colors.green[200],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Reminder",
                  style: TextStyle(
                      color: Variables.blackColor,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1),
                )
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              var uri =
                  'sms:${bill.mobileNo}?body=Dear sir/madam, your payment of ₹ ${(bill.price - bill.givenAmount).toString()} is still pending. Make payment as soon as possible';
              if (await canLaunch(uri)) {
                await launch(uri);
              } else {
                Dialogs.okDialog(context, 'Error', 'Error launching whatsapp',
                    Colors.red[200]);
              }
            },
            child: Column(
              children: [
                Icon(
                  Icons.sms,
                  color: Colors.blue[200],
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "SMS",
                  style: TextStyle(
                      color: Variables.blackColor,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  buildStickyHeaderListView(context) {
    return Container(
        padding: EdgeInsets.all(8),
        height: MediaQuery.of(context).size.height / 4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Container(
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
                "₹ ${amountToBeGiven.toString()}",
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
        ));
  }
}
