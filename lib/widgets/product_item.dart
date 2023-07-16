import 'package:ecom_users/models/cart_moder.dart';
import 'package:ecom_users/models/product_model.dart';
import 'package:ecom_users/pages/product_details_page.dart';
import 'package:ecom_users/providers/cat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';

class ProductItem extends StatefulWidget {
  final ProductModel productModel;

  const ProductItem({super.key, required this.productModel});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, ProductDetailsPage.routeName,
      arguments: widget.productModel.id),
      child: Card(
        elevation: 5,
        child: Stack(
          children: [
            Column(
              children: [
                FadeInImage.assetNetwork(
                  fadeInDuration: const Duration(seconds: 2),
                  fadeInCurve: Curves.bounceInOut,
                  placeholder: 'images/loading.gif',
                  image: widget.productModel.imageUrl!,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.productModel.name!,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                Text(
                  '$currencysymbol ${widget.productModel.salesPrice}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Consumer<CartProvider>(
                  builder: (context, provider, child) {
                    final isInCart = provider.isInCart(widget.productModel.id!);
                    return ElevatedButton.icon(
                      onPressed: () {
                        if(isInCart){
                          provider.removeFromCart(widget.productModel.id!);
                        }else{
                          final cartModel = CartModel(
                              productId: widget.productModel.id!,
                              productName: widget.productModel.name,
                              imageUrl: widget.productModel.imageUrl,
                              salePrice: widget.productModel.salesPrice,
                              stock: widget.productModel.stock,
                              category: widget.productModel.category,
                          );
                          provider.addToCart(cartModel);
                        }
                      },
                      icon: Icon(isInCart
                          ? Icons.remove_shopping_cart
                          : Icons.add_shopping_cart),
                      label: Text(isInCart ? 'Remove' : 'ADD'),
                    );
                  },
                ),
              ],
            ),
            if(widget.productModel.stock ==0 ) Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  color: Colors.black54,
                  child: const Text('OUT OF STOCK',style: TextStyle(color: Colors.white,fontSize: 18),),
                ))
          ],
        ),
      ),
    );
  }
}
