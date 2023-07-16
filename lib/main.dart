

import 'package:ecom_users/pages/cart_page.dart';
import 'package:ecom_users/pages/checkout_page.dart';
import 'package:ecom_users/pages/launcher_page.dart';
import 'package:ecom_users/pages/login_page.dart';
import 'package:ecom_users/pages/order_successful_page.dart';
import 'package:ecom_users/pages/phone_verification_page.dart';
import 'package:ecom_users/pages/product_details_page.dart';
import 'package:ecom_users/pages/product_page.dart';
import 'package:ecom_users/pages/registration_page.dart';
import 'package:ecom_users/pages/user_address_page.dart';
import 'package:ecom_users/providers/cat_provider.dart';
import 'package:ecom_users/providers/order_provider.dart';
import 'package:ecom_users/providers/product_porvider.dart';
import 'package:ecom_users/providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>ProductProvider()),
        ChangeNotifierProvider(create: (context)=>OrderProvider()),
        ChangeNotifierProvider(create: (context)=>UserProvider()),
        ChangeNotifierProvider(create: (context)=>CartProvider()),
      ],
      child: const MyApp()));
  EasyLoading.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: LauncherPage.routeName,
      routes: {

        LauncherPage.routeName: (_) => LauncherPage(),
        LoginPage.routeName: (_) => LoginPage(),
        ProductPage.routeName: (_) => ProductPage(),
        ProductDetailsPage.routeName: (_) => ProductDetailsPage(),
        PhoneVerificationPage.routeName: (_) => PhoneVerificationPage(),
        RegistrationPage.routeName: (_) => RegistrationPage(),
        CartPage.routeName: (_) => CartPage(),
        UserAddressPage.routeName: (_) => UserAddressPage(),
        CheckOutPage.routeName: (_) => CheckOutPage(),
        OrderSuccessfulPage.routeName: (_) => OrderSuccessfulPage(),


      },
    );
  }
}


