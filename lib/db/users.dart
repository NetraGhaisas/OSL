import 'package:cloud_firestore/cloud_firestore.dart';
class UserServices{
  Firestore _firestore = Firestore.instance;
  String collection = "users"; 
  String subcollection = "products";

  void createUser(data){
    print('heyo');
    _firestore.collection(collection).document(data['uid']).setData(data);
    print('done1');
    _firestore.collection(collection).document(data['uid']).collection(subcollection).document("0").setData({});
    print('done2');
  }
}