import 'dart:convert';
import 'dart:io';
import 'package:annaistore/utils/universal_variables.dart';
import 'package:annaistore/widgets/custom_appbar.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';

class LoadAndViewCsvPage extends StatelessWidget {
  final String path;
  const LoadAndViewCsvPage({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: Text("Annai Store", style: Variables.appBarTextStyle),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.grey,
                ),
                onPressed: () {
                  ShareExtend.share(path, "file");
                })
          ],
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Variables.primaryColor,
                size: 16,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          centerTitle: true,
          bgColor: Colors.white),
      body: FutureBuilder(
        future: _loadCsvData(),
        builder: (_, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: snapshot.data
                    .map(
                      (row) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            // Name
                            Text(row[0].toString()),
                            //Coach
                            Text(row[1].toString()),
                            Text(row[2].toString()),
                            Text(row[3].toString()),
                            Text(row[4].toString()),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          }

          return Center(
            child: Text('no data found !!!'),
          );
        },
      ),
    );
  }

  Future<List<List<dynamic>>> _loadCsvData() async {
    try {
      final file = new File(path).openRead();
      return await file
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();
    } catch (e) {
      return null;
    }
  }
}
