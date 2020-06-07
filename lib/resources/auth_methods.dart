import 'package:annaistore/constants/strings.dart';
import 'package:annaistore/models/user.dart';
import 'package:annaistore/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  static final Firestore _firestore = Firestore.instance;

  CollectionReference _userCollection = _firestore.collection(USERS_COLLECTION);

  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _signInAuthentication.idToken,
        accessToken: _signInAuthentication.accessToken);
    AuthResult result = await _auth.signInWithCredential(credential);
    FirebaseUser user = result.user;

    return user;
  }

  Future<bool> authenticateUser(FirebaseUser user) async {
    QuerySnapshot result = await _firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: user.email)
        .getDocuments();

    final List<DocumentSnapshot> docs = result.documents;

    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(FirebaseUser currentUser) async {
    String username = Utils.getUsername(currentUser.email);

    User user = User(
      email: currentUser.email,
      uid: currentUser.uid,
      name: currentUser.displayName,
      profilePhoto: currentUser.photoUrl,
      username: username,
      role: USER_STRING
    );

    _firestore
        .collection(USERS_COLLECTION)
        .document(currentUser.uid)
        .setData(user.toMap(user));
  }

  Future<User> getUserDetailsById(String userId) async {
    try {
      print("UserId: $userId");
      DocumentSnapshot doc = await _userCollection.document(userId).get();
      print(doc.data);
      return User.fromMap(doc.data);
    } catch (e) {
      print("get user by details error: $e");
      return null;
    }
  }

}
