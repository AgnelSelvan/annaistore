import 'package:annaistore/utils/universal_variables.dart';
import 'package:flutter/material.dart';

enum DialogAction { yes, Abort }

class Dialogs {
  static Future<DialogAction> yesAbortDialog(
      BuildContext context, String title, String body, GestureTapCallback yesOnTap ) async {
    final action = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(title),
            content: Text(body),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(DialogAction.Abort);
                },
                child: Text("No", style: TextStyle(color: Variables.primaryColor),),
              ),
              RaisedButton(
                elevation: 0,
                color: Variables.primaryColor,
                onPressed: yesOnTap,
                child: Text("Yes", style: TextStyle(color: Variables.lightGreyColor),),
              )
            ],
          );
        });
    return (action != null) ? action : DialogAction.Abort;
  }
}
