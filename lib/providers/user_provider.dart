
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_users/db/dbhepler.dart';
import 'package:ecom_users/models/city_model.dart';
import 'package:ecom_users/models/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProvider extends ChangeNotifier {

  UserModel? userModel; //userModel nam e ekta proparty rakhlam
  List<CityModel> cityList = [];

  getAllCities(){
    DbHelper.getAllCities().listen((snapshot) {
      cityList = List.generate(snapshot.docs.length, (index) =>
          CityModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  List<String>getAreasByCity(String? city){
    if(city != null) {
      return cityList.firstWhere((element) =>
      element.name == city).area;
    }else{
      return <String> [];
    }
  }

  Future<void> addUser (UserModel userModel) =>
      DbHelper.addUser(userModel);

  Future<bool> doesUserExist(String uid) => DbHelper.doesUserExist(uid);

  Stream<DocumentSnapshot<Map<String,dynamic>>> getUserByUid(String uid) =>
      DbHelper.getUserByUid(uid);/*user Doc*/

  Future<void> updateProfile(String uid,Map<String,dynamic>map)=>
      DbHelper.updateProfile(uid,map);

  Future<String> updateImage(XFile xFile) async {
    final imageName = DateTime.now().millisecondsSinceEpoch.toString();
    final photoRef = FirebaseStorage.instance.ref().child('ProfilePictures/$imageName');
    final uploadTask = photoRef.putFile(File(xFile.path));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }

}