import 'package:cloud_firestore/cloud_firestore.dart';

class Utils{
  static String getUsername(String email) {
    return "${email.split('@')[0]}";
  }

  static String getDocId(){
    return Firestore.instance.collection('customers').document().documentID;
  }

}