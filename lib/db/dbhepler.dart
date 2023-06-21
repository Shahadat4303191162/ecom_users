import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_users/models/cart_moder.dart';
import 'package:ecom_users/models/product_model.dart';
import 'package:ecom_users/models/user_model.dart';



class DbHelper{


  static const String collectionCategory = 'categories';
  static const String collectionProduct = 'product';
  static const String collectionUsers = 'Users';
  static const String collectionCart = 'Cart';
  static const String collectionCities = 'Cities';
  static const String collectionOrderSettings = 'settings';
  static const String documentOrderConstant = 'orderConstant';
  static final FirebaseFirestore _db = FirebaseFirestore.instance;



  static Future<void> addUser (UserModel userModel) =>
      _db.collection(collectionUsers).doc(userModel.uid)
          .set(userModel.toMap());


  static Future<void> addToCart (CartModel cartModel,String uid) =>
      _db.collection(collectionUsers).doc(uid)
      .collection(collectionCart)
      .doc(cartModel.productId)
          .set(cartModel.toMap());


  static Future<void> removeFromCart (String pid,String uid) =>
      _db.collection(collectionUsers).doc(uid)
          .collection(collectionCart)
          .doc(pid)
          .delete();

  static Future<void> updateCartQuantity (String pid,String uid,num quantity) =>
      _db.collection(collectionUsers).doc(uid)
          .collection(collectionCart)
          .doc(pid)
          .update({cartProductQuantity : quantity});

  static Stream<QuerySnapshot<Map<String,dynamic>>> getCartByUser(String uid) =>
      _db.collection(collectionUsers)
          .doc(uid)
          .collection(collectionCart)
          .snapshots();

  static Future<bool> doesUserExist(String uid) async{
    final snapshot =await _db.collection(collectionUsers).doc(uid).get();
    return snapshot.exists;
  }

  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllCities() =>
      _db.collection(collectionCities).snapshots();


  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllProduct() =>
      _db.collection(collectionProduct).snapshots();

  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllProductsByCategory(String category) =>
      _db.collection(collectionProduct).where(productCategory,isEqualTo: category).snapshots();

  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllFeaturedProducts() =>
      _db.collection(collectionProduct).where(productFeatured,isEqualTo: true).snapshots();


  static Stream<DocumentSnapshot<Map<String,dynamic>>> getProductById(String id) =>
      _db.collection(collectionProduct).doc(id).snapshots();

  static Stream<DocumentSnapshot<Map<String,dynamic>>> getOrderConstants() => /*2.1 orderSettings*/
      _db.collection(collectionOrderSettings).doc(documentOrderConstant).snapshots();

  static Future<DocumentSnapshot<Map<String,dynamic>>> getOrderConstants2() => /*2.1 orderSettings*/
  _db.collection(collectionOrderSettings).doc(documentOrderConstant).get();

  static Stream<DocumentSnapshot<Map<String,dynamic>>> getUserByUid(String uid) =>
      _db.collection(collectionUsers).doc(uid).snapshots();

  static Future<void> updateProfile(String uid, Map<String, dynamic> map) {
    return _db.collection(collectionUsers).doc(uid).update(map);
  }


}