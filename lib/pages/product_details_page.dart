import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_users/utils/constants.dart';
import 'package:ecom_users/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:provider/provider.dart';


import '../models/product_model.dart';
import '../providers/product_porvider.dart';

class ProductDetailsPage extends StatelessWidget {
  static const String routeName = '/product_details';
  ValueNotifier<DateTime> dateChangeNotifier = ValueNotifier(DateTime.now());
  ProductDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    dateChangeNotifier.value = DateTime.now();
    final pid = ModalRoute.of(context)!.settings.arguments as String;
    final provider = Provider.of<ProductProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: provider.getProductById(pid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final product = ProductModel.fromMap(snapshot.data!.data()!);
              return ListView(
                children: [
                  FadeInImage.assetNetwork(
                    placeholder: 'images/loading.gif',
                    image: product.imageUrl!,
                    fadeInDuration: const Duration(seconds: 1),
                    fadeInCurve: Curves.bounceInOut,
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  ListTile(
                    title: Text(product.name!),
                    subtitle: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${product.rating}'),
                        const SizedBox(width: 5,),
                        RatingBar.builder(
                          itemSize: 15,
                          ignoreGestures: true,
                          initialRating: 0,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                          },
                        ),
                        const SizedBox(width: 5,),
                        Text('(${product.ratingCount})')
                      ],
                    ),

                  ),
                  ListTile(
                    title: Text('$currencysymbol${product.salesPrice}'),

                  ),
                  ListTile(
                    title: const Text('Product Description'),
                    subtitle: Text(product.description ?? 'NOt Available'),

                  ),
                  ElevatedButton(
                      onPressed: () async{
                        final status = await provider.canUserRate(pid);
                        if(status){
                          _showRatingDialog(context,product, (value) async{
                            await provider.addRating(product.id!, value);
                          });
                        }else {
                          showMsg(context, 'You cannot rate');
                        }
                      }, child: const Text('Rate this product'),)
                ],
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Failed to get data'),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
    );
  }

  void _showRatingDialog(BuildContext context, ProductModel product,Function(double) onRate) {
    double userRating =0.0;
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Rate ${product.name}'),
      content: RatingBar.builder(
        initialRating: 3,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {
          userRating = rating; // je man ta pacci ta sudu matro curlibress er maddei pacci,tai upore ekta variable newa holo
        },
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () {
            onRate(userRating);
            Navigator.pop(context);
          },
          child: const Text('RATE'),
        ),
      ],
    ),);
  }


}
