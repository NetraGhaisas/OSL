import 'package:cloud_firestore/cloud_firestore.dart';
class UserServices{
  Firestore _firestore = Firestore.instance;
  String collection = "users"; 
  String subcollection = "products";

  void createUser(Map data){
    _firestore.collection(collection).document(data["uid"]).setData(data);
    _firestore.collection(collection).document(data["uid"]).collection(subcollection).document("0").setData({});
  }
}