import 'package:ecom_users/pages/checkout_page.dart';
import 'package:ecom_users/pages/user_address_page.dart';
import 'package:ecom_users/providers/cat_provider.dart';
import 'package:ecom_users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  static const String routeName ='/cartPage';
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Expanded(child: ListView.builder(
                itemBuilder: (context, index) {
                  final cartM = provider.cartList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        cartM.imageUrl!
                      ),
                    ),
                    title: Text(cartM.productName!),
                    trailing: Text('$currencysymbol ${provider.unitPriceWithQunatity(cartM)}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Unit Price: $currencysymbol ${cartM.salePrice}'),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: (){
                                  provider.decreaseQuantity(cartM);

                                },
                                icon: Icon(Icons.remove_circle_outline),
                            ),
                            Text('${cartM.quantity}',style: const TextStyle(fontSize: 18),),
                            IconButton(
                              onPressed: (){
                                provider.increaseQuantity(cartM);
                              },
                              icon: Icon(Icons.add_circle_outline),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: (){
                                provider.removeFromCart(cartM.productId!);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
                itemCount: provider.cartList.length,
            ),
            ),
            Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal:  $currencysymbol${provider.getCartSubTotal()}',
                        style: TextStyle(fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green
                        ),),
                        TextButton(
                            onPressed: provider.totalItemsInCart == 0 ? null : () {
                              Navigator.pushNamed(context, CheckOutPage.routeName);
                            },
                            child: const Text('CHECKOUT'),)
                      ],
                    ),
                  ),
                ),
            )
          ],
        ),
      ),
    );
  }
}
