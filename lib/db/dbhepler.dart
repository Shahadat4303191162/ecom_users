import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_users/models/cart_moder.dart';
import 'package:ecom_users/models/notification_model.dart';
import 'package:ecom_users/models/order_model.dart';
import 'package:ecom_users/models/product_model.dart';
import 'package:ecom_users/models/rating_model.dart';
import 'package:ecom_users/models/user_model.dart';
import 'package:ecom_users/utils/constants.dart';

import '../models/category_model.dart';



class DbHelper{


  static const String collectionCategory = 'categories';
  static const String collectionProduct = 'product';
  static const String collectionRating = 'Rating';
  static const String collectionComment = 'Comment';
  static const String collectionUsers = 'Users';
  static const String collectionCart = 'Cart';
  static const String collectionOrder = 'Order';
  static const String collectionOrderDetails = 'OrderDetails';
  static const String collectionCities = 'Cities';
  static const String collectionOrderSettings = 'settings';
  static const String documentOrderConstant = 'orderConstant';
  static const String collectionNotification = 'Notification';
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

  static Future<void> clearAllCartItems(String uid, List<CartModel> cartList){
    final wb = _db.batch();
    final userDoc = _db.collection(collectionUsers).doc(uid);
    for(var cartM in cartList){
      final cartDoc = userDoc.collection(collectionCart).doc(cartM.productId);
      wb.delete(cartDoc);
    }
    return wb.commit();
  }

  static Future<void> updateCategoryProductCount (List<CategoryModel> catList,List<CartModel> cartList){
    final wb = _db.batch();
    for(var cartM in cartList){
      final catModel = catList.firstWhere((element) => element.name == cartM.category);
      final catDoc = _db.collection(collectionCategory).doc(catModel.id);
      wb.update(catDoc, {categoryProductCount: (catModel.productCount - cartM.quantity)});
    }
    return wb.commit();
  }
  static Future<void> updateCartQuantity (String pid,String uid,num quantity) =>
      _db.collection(collectionUsers).doc(uid)
          .collection(collectionCart)
          .doc(pid)
          .update({cartProductQuantity : quantity});

  static Future<void> updateProduct(String pid, Map<String, dynamic>map){
    return _db.collection(collectionProduct)
        .doc(pid)
        .update(map);
  }

  static Stream<QuerySnapshot<Map<String,dynamic>>> getCartByUser(String uid) =>
      _db.collection(collectionUsers)
          .doc(uid)
          .collection(collectionCart)
          .snapshots();

  static Future<void> addOrder(OrderModel orderModel, List<CartModel> cartList){
    final wb =_db.batch();
    final orderDoc = _db.collection(collectionOrder).doc();
    orderModel.orderId = orderDoc.id;
    wb.set(orderDoc,orderModel.toMap());//
    for(var cartM in cartList){
      final detailsDoc = orderDoc.collection(collectionOrderDetails).doc(cartM.productId);
      wb.set(detailsDoc, cartM.toMap());
      final productDoc = _db.collection(collectionProduct).doc(cartM.productId);
      wb.update(productDoc, {productStock : (cartM.stock - cartM.quantity)});

    }
    return  wb.commit();
  }

  static Future<bool> doesUserExist(String uid) async{
    final snapshot =await _db.collection(collectionUsers).doc(uid).get();
    return snapshot.exists;
  }

  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllCities() =>
      _db.collection(collectionCities).snapshots();


  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String,dynamic>>> getAllProduct() =>
      _db.collection(collectionProduct)
          .where(productAvailable,isEqualTo: true)
          .snapshots();

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

  static Future<QuerySnapshot<Map<String,dynamic>>> getAllRatingByProduct(String pid) =>
      _db.collection(collectionProduct)
          .doc(pid)
          .collection(collectionRating)
          .get();

  static Future<void> updateProfile(String uid, Map<String, dynamic> map) {
    return _db
        .collection(collectionUsers)
        .doc(uid)
        .update({'address' : map});
  }

  static Future<bool> canUserRate(String uid,String pid) async{
    final snapshot = await _db.collection(collectionOrder)
        .where(userIDKey, isEqualTo: uid)
        .where(orderStatusKey, isEqualTo: OrderStatus.delivered)
        .get();
    if(snapshot.docs.isEmpty) return false;
    bool tag = false;
    for(var doc in snapshot.docs){
      final detailsSnapshot = await doc.reference.collection(collectionOrderDetails)
          .where(cartProductId, isEqualTo: pid)
          .get();
      if(detailsSnapshot.docs.isNotEmpty){
        tag = true;
        break;
      }
    }
    return tag;
  }

  static Future<void> addRating(RatingModel ratingModel) {
    return _db.collection(collectionProduct)
        .doc(ratingModel.productId)
        .collection(collectionRating)
        .doc(ratingModel.userId)
        .set(ratingModel.toMap());
  }

  static Future<void> addNotification(NotificationModel notificationModel){
    return _db.collection(collectionNotification).doc(notificationModel.id).set(notificationModel.toMap());
  }

}