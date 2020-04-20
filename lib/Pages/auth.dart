import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/users.dart';

abstract class BaseAuth {
  Future<FirebaseUser> googleSignIn();

  Future<String> login(String email, String password);

  Future<String> register(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  static var _key = 'uid';
  @override
  Future<FirebaseUser> googleSignIn() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    try {
      FirebaseUser user =
          (await _firebaseAuth.signInWithCredential(credential)).user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> login(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      print('yay');
      FirebaseUser user = result.user;
      await _storeUID(user.uid);
      print('store uid done');
    } catch (pe) {
      return 'Invalid credentials';
    }
    return null;
  }

  Future<String> register(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      // Map usermap = {
      //   "uid": user.uid,
      //   "email": email,
      // };
      this.makeUser(user.uid, email);
      await _storeUID(user.uid);
      print('store uid done');
    } catch (pe) {
      print(pe.toString());
      return 'Invalid credentials';
    }
    return null;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    return _firebaseAuth.signOut();
  }

  _storeUID(uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uidString = await uid;
    await prefs.setString(_key, uidString);
  }

  static getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uidString = await prefs.get(_key);
    return uidString;
  }

  void makeUser(uid, email) async {
    String collection = "users";
    String subcollection = "products";
    Map data = {
      "uid": uid,
      "email": email,
    };
    _firestore.collection(collection).document(uid).setData({
      "uid": uid,
      "email": email,
    });
  }
}
