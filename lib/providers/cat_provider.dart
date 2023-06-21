import 'dart:math';

import 'package:ecom_users/auth/auth_service.dart';
import 'package:ecom_users/db/dbhepler.dart';
import 'package:flutter/material.dart';

import '../models/cart_moder.dart';

class CartProvider extends ChangeNotifier{
  List<CartModel> cartList = [];

  int get totalItemsInCart => cartList.length;

  num unitPriceWithQunatity (CartModel cartModel)=>
  cartModel.salePrice * cartModel.quantity;







  Future<void> addToCart(CartModel cartModel) =>
      DbHelper.addToCart(cartModel, AuthService.user!.uid);

  Future<void> removeFromCart(String pid) =>
      DbHelper.removeFromCart(pid,AuthService.user!.uid);

  getCartByUser(){
    DbHelper.getCartByUser(AuthService.user!.uid).listen((snapshot) {
      cartList = List.generate(snapshot.docs.length, (index) =>
          CartModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<void> _updateCartQuantity (String pid,num quantity)=>
    DbHelper.updateCartQuantity(pid, AuthService.user!.uid, quantity);

  Future<void> increaseQuantity(CartModel cartModel) async{
     await _updateCartQuantity(cartModel.productId!, cartModel.quantity + 1);
  }

  Future<void> decreaseQuantity(CartModel cartModel) async{
    if(cartModel.quantity>1){
      await  _updateCartQuantity(cartModel.productId!, cartModel.quantity - 1);
    }
  }

  bool isInCart(String pid){
    bool tag = false;
    for (var cartM in cartList){
      if(cartM.productId == pid){
        tag = true;
        break;
      }
    }
    return tag;
  }

  num getCartSubTotal(){
    num total = 0;
    for (var cartM in cartList){
      total +=cartM.salePrice * cartM.quantity;
    }
    return total;

  }

}