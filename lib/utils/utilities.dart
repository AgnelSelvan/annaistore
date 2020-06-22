import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Utils {
  static String getUsername(String email) {
    return "${email.split('@')[0]}";
  }

  static String getUniqueId() {
    Random random = new Random();
    int randomNumber = random.nextInt(900000) + 100000;
    return randomNumber.toString();
  }

  static String getDocId() {
    return Firestore.instance.collection('customers').document().documentID;
  }

  static String getPhoneDisplayName() {
    String uniqueNumber = getUniqueId();
    return 'User$uniqueNumber';
  }
}
