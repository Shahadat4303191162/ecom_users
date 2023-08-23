
import 'package:ecom_users/db/dbhepler.dart';
import 'package:ecom_users/models/notification_model.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider extends ChangeNotifier{
  Future<void> addNotification(NotificationModel notificationModel){
    return DbHelper.addNotification(notificationModel);
  }
}