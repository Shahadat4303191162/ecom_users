import 'package:cloud_firestore/cloud_firestore.dart';



class DbHelper{


  static const String collectionCategory = 'categories';
  static const String collectionProduct = 'product';
  static const String collectionOrderSettings = 'settings';
  static const String documentOrderConstant = 'orderConstant';
  static final FirebaseFirestore _db = FirebaseFirestore.instance;



  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllProduct() =>
      _db.collection(collectionProduct).snapshots();


  static Stream<DocumentSnapshot<Map<String,dynamic>>> getProductById(String id) =>
      _db.collection(collectionProduct).doc(id).snapshots();

  static Stream<DocumentSnapshot<Map<String,dynamic>>> getOrderConstants() => /*2.1 orderSettings*/
      _db.collection(collectionOrderSettings).doc(documentOrderConstant).snapshots();

  static Future<DocumentSnapshot<Map<String,dynamic>>> getOrderConstants2() => /*2.1 orderSettings*/
  _db.collection(collectionOrderSettings).doc(documentOrderConstant).get();


}