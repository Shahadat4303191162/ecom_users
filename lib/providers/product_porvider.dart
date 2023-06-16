import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../db/dbhepler.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';


class ProductProvider extends ChangeNotifier{

  List<CategoryModel> categoryList = [];//object
  List<ProductModel> productList = [];

  getAllCategories(){
    DbHelper.getAllCategories().listen((snapshot){
      categoryList = List.generate(snapshot.docs.length, (index) =>
        CategoryModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllProducts(){
    DbHelper.getAllProduct().listen((snapshot) {
      productList = List.generate(snapshot.docs.length, (index) =>
        ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }


  Stream<DocumentSnapshot<Map<String,dynamic>>> getProductById(String id) =>
    DbHelper.getProductById(id);

  Future<String> updateImage(XFile xFile) async {
    final imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final photoRef = FirebaseStorage.instance.ref().child('Pictures/$imageName');
    final uploadTask = photoRef.putFile(File(xFile.path));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }
}