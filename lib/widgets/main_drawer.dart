import 'package:ecom_users/pages/cart_page.dart';
import 'package:ecom_users/pages/login_page.dart';
import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../pages/launcher_page.dart';


class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            height: 200,
            color: Theme.of(context).primaryColor,
          ),
          ListTile(
            onTap: () {
              //Navigator.pushNamed(context, UserProfilePage.routeName);
            },
            leading: Icon(Icons.person),
            title: const Text('My Profile'),
          ),

          ListTile(
            onTap: () {
              Navigator.pushNamed(context, CartPage.routeName);
            },
            leading: Icon(Icons.shopping_cart),
            title: const Text('My Cart'),
          ),

          ListTile(
            onTap: () {
              AuthService.logout().then((value) =>
                  Navigator.pushReplacementNamed(
                      context, LoginPage.routeName));
            },
            leading: const Icon(Icons.logout),
            title: const Text('LOGOUT'),
          ),
        ],
      ),
    );
  }
}