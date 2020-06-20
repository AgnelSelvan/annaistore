import 'dart:io';
import 'dart:typed_data';
import 'package:annaistore/models/user.dart';
import 'package:annaistore/models/yougave.dart';
import 'package:annaistore/resources/admin_methods.dart';
import 'package:annaistore/resources/auth_methods.dart';
import 'package:annaistore/screens/admin/borrow/pdf_viewer.dart';
import 'package:annaistore/screens/custom_loading.dart';
import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/custom_appbar.dart';
import 'package:annaistore/widgets/dialogs.dart';
import 'package:annaistore/widgets/widgets.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey _containerKey = GlobalKey();
  User currentUser;
  final _imageSaver = ImageSaver();
  // VoidCallback
  BorrowModel borrowModel;
  bool isLoading = false;
  final pdf = pw.Document();

  getBorrowById() async {
    setState(() {
      isLoading = true;
    });
    BorrowModel _borrowModel =
        await _adminMethods.getBorrowById(widget.borrowId);
    setState(() {
      borrowModel = _borrowModel;
    });
  }

  getCurrentUser() async {
    setState(() {
      isLoading = true;
    });
    FirebaseUser user = await _authMethods.getCurrentUser();
    User nowUser = await _authMethods.getUserDetailsById(user.uid);
    setState(() {
      currentUser = nowUser;
    });
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

    // final file = await new File('${dir.path}/sample.png').create();
    // file.writeAsBytesSync(png);
    // print(file);

    // String base64 = base64Encode(png);
    // String BASE64_IMAGE = "data:image/png;base64, ...";
    // AdvancedShare.whatsapp(msg: "Hii", url: BASE64_IMAGE).then((response) {
    //   print(response);
    // });

    // var uri =
    //     "https://wa.me/${borrowModel.mobileNo}?text=Dear sir/madam, your payment of ₹ ${(borrowModel.price - borrowModel.givenAmount).toString()} is still pending. Make payment as soon as possible";
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

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  checkInternetConnection() async {
    setState(() {
      isLoading = true;
    });
    var status = await _authMethods.checkInternet();
    if (status == DataConnectionStatus.connected) {
      getBorrowById();
      getCurrentUser();
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("No internet"),
                content: Text("Check your internet connection"),
              ));
    }
    setState(() {
      isLoading = false;
    });
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
              Text(
                borrowModel.billNo == null
                    ? 'Error Loading...'
                    : borrowModel.billNo,
                style: TextStyle(
                    color: Variables.blackColor,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.3),
              )
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
              Text(
                DateFormat('dd/MM/yyyy').format(borrowModel.timestamp.toDate()),
                style: TextStyle(
                    color: Variables.blackColor,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.3),
              )
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
              Text(
                "₹${borrowModel.price.toString()}",
                style: TextStyle(
                    color: Variables.blackColor,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.3),
              )
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
              Text(
                "₹${borrowModel.givenAmount.toString()}",
                style: TextStyle(
                    color: Variables.blackColor,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.3),
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  "Total Price",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: .5),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "₹${(borrowModel.price - borrowModel.givenAmount).toString()}",
                style: TextStyle(
                    color: Variables.blackColor,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.3),
              )
            ],
          )
        ],
      ),
    );
  }

  generatePdfAndView(context) async {
    print('pdf');
    // final pw.Document pdf = pw.Document(deflate: zlib.encode);

    // pdf.addPage(pw.MultiPage(
    //     build: (context) => [
    //           pw.Table.fromTextArray(context: context, data: <List<String>>[
    //             <String>['Bill No', 'Product', 'price'],
    //             [
    //               borrowModel.billNo.toString(),
    //               ...borrowModel.productList.map((e) => e.toString()),
    //               ...borrowModel.qtyList.map((e) => e.toString())
    //             ]
    //           ])
    //         ]));
    // print('Generation done!');
    // final String dir = (await getApplicationDocumentsDirectory()).path;
    // String path = '$dir/myoutput.pdf';
    // print(path);
    // final File file = File(path);

    // file.writeAsBytesSync(pdf.save());

    final pw.Document pdf = pw.Document();
    pdf.addPage(
        //Your PDF design here with the widget system of the plugin
        pw.MultiPage(
      pageFormat:
          PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      header: (pw.Context context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: const pw.BoxDecoration(
                border: pw.BoxBorder(
                    bottom: true, width: 0.5, color: PdfColors.grey)),
            child: pw.Text('VCR',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
    ));
    Directory output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/example.pdf');

    await file.writeAsBytes(pdf.save(), flush: true);

    return '${output.path}/example.pdf';
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
                        Text(
                            "₹${(borrowModel.price - borrowModel.givenAmount).toString()}",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w500)),
                        Text(
                            DateFormat('dd/MM/yyyy')
                                .format(borrowModel.timestamp.toDate()),
                            style: TextStyle(
                                color: Variables.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.5)),
                        Text("Sent by ${currentUser.name}",
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

  buildBodyHeadButtons() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () async {
              String fullPath = await generatePdfAndView(context);
              print(fullPath);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PdfPreviewwScreen(
                            path: fullPath,
                          )));
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
                  'sms:${borrowModel.mobileNo}?body=Dear sir/madam, your payment of ₹ ${(borrowModel.price - borrowModel.givenAmount).toString()} is still pending. Make payment as soon as possible';
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
      child: FutureBuilder(
          future: _adminMethods.getBorrowById(widget.borrowId),
          builder: (context, AsyncSnapshot<BorrowModel> snapshot) {
            if (!snapshot.hasData) {
              return CustomCircularLoading();
            }
            // BorrowModel borrowModel = BorrowModel.fromMap(snapshot.data.);
            return Container(
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
                    "₹ ${(snapshot.data.price - snapshot.data.givenAmount).toString()}",
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
            );
          }),
    );
  }
}
