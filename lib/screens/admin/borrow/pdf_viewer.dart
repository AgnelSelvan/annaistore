import 'package:annaistore/screens/admin/borrow/borrow_list.dart';
import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/bouncy_page_route.dart';
import 'package:annaistore/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class PdfPreviewwScreen extends StatelessWidget {
  final String path;
  PdfPreviewwScreen({this.path});

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: CustomAppBar(
            title: Text(
              'Annai Store',
              style: TextStyle(color: Variables.primaryColor),
            ),
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.share,
                    size: 18,
                    color: Colors.blue[200],
                  ),
                  onPressed: null)
            ],
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 18,
                  color: Variables.primaryColor,
                ),
                onPressed: () {
                  Navigator.push(
                      context, BouncyPageRoute(widget: BorrowList()));
                }),
            centerTitle: true,
            bgColor: Variables.lightGreyColor),
        path: path);
  }
}
