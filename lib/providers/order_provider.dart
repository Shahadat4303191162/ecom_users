
import 'package:ecom_users/models/order_model.dart';
import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../db/dbhepler.dart';
import '../models/cart_moder.dart';
import '../models/category_model.dart';
import '../models/order_constants_model.dart';

class OrderProvider extends ChangeNotifier{
  OrderConstantsModel orderConstantsModel = OrderConstantsModel();
  //query korar age object cr korlam cz default value 0


  Future<void> addOrder(OrderModel orderModel,List<CartModel> cartList){
    return DbHelper.addOrder(orderModel, cartList);
  }
  Future<void> updateCategoryProductCount(List<CartModel> cartList,List<CategoryModel> catList)=>
      DbHelper.updateCategoryProductCount(catList, cartList);

  Future<void> clearAllCartItems(List<CartModel> cartList) =>
      DbHelper.clearAllCartItems(AuthService.user!.uid, cartList);

  getOrderConstant(){
    DbHelper.getOrderConstants().listen((event) {
      if(event.exists){
        orderConstantsModel = OrderConstantsModel.fromMap(event.data()!);
        notifyListeners();
      }
    });
  }

  Future<void> getOrderConstant2() async{
    final snapshot = await DbHelper.getOrderConstants2();
    orderConstantsModel = OrderConstantsModel.fromMap(snapshot.data()!);
    notifyListeners();
  }

  num getDiscountAmount(num subtotal){
    return (subtotal * orderConstantsModel.discount)/100;
  }

  num getVatAmount(num subtotal){
    final priceAfterDiscount = subtotal - getDiscountAmount(subtotal).round();
    return (priceAfterDiscount * orderConstantsModel.vat)/100;
  }

  num getGrandTotal(num subtotal){
    final priceAfterDiscount = subtotal - getDiscountAmount(subtotal);
    final vatAmount = getVatAmount(subtotal).round();
    return vatAmount + orderConstantsModel.deliveryCharge + priceAfterDiscount.round();
  }

}