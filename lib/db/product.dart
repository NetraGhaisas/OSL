import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  Firestore _firestore = Firestore.instance;

  void uploadProduct(
      {String uid,
      String productName,
      String category,
      int price,
      int quantity,
      String image,
      String date,
      int threshold}) {
    var id = Uuid();
    String productId = id.v1();
    String ref = 'users/' + uid + '/products';

    _firestore.collection(ref).document(productId).setData({
      'name': productName,
      'id': productId,
      'category': category,
      'quantity': quantity,
      'price': price,
      'picture': image,
      'date': date,
      'threshold': threshold,
    });
  }

  void updateProduct(
      {String uid,
      String productId,
      String productName,
      String category,
      int price,
      int quantity,
      String image,
      String date,
      int threshold}) {
        print(uid);
    String ref = 'users/' + uid + '/products';
    
    _firestore.collection(ref).document(productId).setData({
      'name': productName,
      'id': productId,
      'category': category,
      'quantity': quantity,
      'price': price,
      'picture': image,
      'date': date,
      'threshold': threshold,
    });
  }

  getproduct(String uid, String cate) {
    String ref = 'users/' + uid + '/products';
    return _firestore
        .collection(ref)
        .where('category', isEqualTo: cate)
        .getDocuments();
  }

  Future<List<DocumentSnapshot>> getAllProducts(String uid) {
    print(uid);
    return _firestore
        .collection('users/' + uid + '/products')
        .getDocuments()
        .then((snaps) {
      print('SNAPS products $snaps');
      return snaps.documents;
    });
  }
}
