import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_users/auth/auth_service.dart';
import 'package:ecom_users/models/data_model.dart';
import 'package:ecom_users/models/order_model.dart';
import 'package:ecom_users/models/user_model.dart';
import 'package:ecom_users/pages/order_successful_page.dart';
import 'package:ecom_users/pages/product_page.dart';
import 'package:ecom_users/pages/user_address_page.dart';
import 'package:ecom_users/providers/cat_provider.dart';
import 'package:ecom_users/providers/order_provider.dart';
import 'package:ecom_users/providers/product_porvider.dart';
import 'package:ecom_users/providers/user_provider.dart';
import 'package:ecom_users/utils/constants.dart';
import 'package:ecom_users/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/adddress_model.dart';

class CheckOutPage extends StatefulWidget {
  static const String routeName = '/checkout';

  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  late CartProvider cartProvider;
  late OrderProvider orderProvider;
  late UserProvider userProvider;
  String paymentMethodGroupValue = PaymentMethod.cod;
  bool isFirst = true;

  @override
  void didChangeDependencies() {
    if(isFirst) {
      cartProvider = Provider.of<CartProvider>(context);
      orderProvider = Provider.of<OrderProvider>(context);
      userProvider = Provider.of<UserProvider>(context, listen: false);
      orderProvider.getOrderConstant();
      isFirst = false;
    }
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Text(
                  'Product Info',
                  style: Theme.of(context).textTheme.headline5,
                ),
                Card(
                  elevation: 5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: cartProvider.cartList
                        .map((cartM) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  cartM.imageUrl!
                                )
                              ),
                              title: Text(cartM.productName!),
                              trailing: Text(
                                  '${cartM.quantity}X$currencysymbol ${cartM.salePrice}'),
                            ))
                        .toList(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Payment Info',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal'),
                            Text('$currencysymbol${cartProvider.getCartSubTotal()}'),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Delivery Charge'),
                            Text('$currencysymbol${orderProvider.orderConstantsModel.deliveryCharge}'),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Discount (${orderProvider.orderConstantsModel.discount})%'),
                            Text('-$currencysymbol${orderProvider.getDiscountAmount(cartProvider.getCartSubTotal())}'),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('VAT (${orderProvider.orderConstantsModel.discount})%'),
                            Text('$currencysymbol${orderProvider.getVatAmount(cartProvider.getCartSubTotal())}'),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        const Divider(height: 1.5,color: Colors.black,),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Grand Total'),
                            Text('$currencysymbol${orderProvider.getGrandTotal(cartProvider.getCartSubTotal())}',style: Theme.of(context).textTheme.headline6),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Delivery Address',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 5,
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: userProvider.getUserByUid(AuthService.user!.uid),
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        final userM = UserModel.fromMap(snapshot.data!.data()!);
                        userProvider.userModel = userM;
                        final addressM = userM.address;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(addressM == null ? 'No address found' :
                              '${addressM.streetAddress}\n'
                                  '${addressM.area}, ${addressM.city}\n'
                                  '${addressM.zipCode}'),
                              ElevatedButton(
                                onPressed: () => Navigator.pushNamed(context, UserAddressPage.routeName),
                                child: const Text('Change'),
                              )
                            ],
                          ),
                        );
                      }
                      if(snapshot.hasError) {
                        return Center(child: const Text('Failed to fetch data'),);
                      }

                      return Center(child: const Text('Fetching address...'),);
                    },
                  ),
                ),
                // Card(
                //   elevation: 5,
                //   child: StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>( /*user Doc*/
                //       stream: userProvider.getUserByUid(AuthService.user!.uid),
                //     builder: (context, snapshot) {
                //       if(snapshot.hasData){
                //         final userM = UserModel.fromMap(snapshot.data!.data()!);
                //         userProvider.userModel = userM;
                //         return Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Text(userM.address == null? 'No address set yet':
                //             '${userM.address!.streetAddress} \n'
                //                 '${userM.address!.area},${userM.address!.city}\n'
                //                   '${userM.address!.zipCode}',style: TextStyle(fontWeight: FontWeight.bold),),
                //             ElevatedButton(
                //                 onPressed: () => Navigator.pushNamed(context, UserAddressPage.routeName),
                //                 child: const Text('Change'),),
                //
                //           ],
                //         );
                //       }
                //       if(snapshot.hasError){
                //         return const Text('Failed to fetch user data');
                //       }
                //       return const Text('Fetching user data....');
                //     },
                //       ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Payment Method',
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: Row(
                      children: [
                        Radio<String>(
                            value: PaymentMethod.cod,
                            groupValue: paymentMethodGroupValue,
                            onChanged: (value){
                              setState(() {
                                paymentMethodGroupValue = value!;
                              });
                            },
                        ),
                        const Text(PaymentMethod.cod),
                        const SizedBox(width: 15,),
                        Radio<String>(
                          value: PaymentMethod.online,
                          groupValue: paymentMethodGroupValue,
                          onChanged: (value){
                            setState(() {
                              paymentMethodGroupValue = value!;
                            });
                          },
                        ),
                        const Text(PaymentMethod.online),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white
              ),
              onPressed: _saveOrder,
              child: const Text('Place Order'))
        ],
      ),
    );
  }

  void _saveOrder() {
    if(userProvider.userModel?.address == null){
      showMsg(context, 'Please provide a delivery address');
      return;
    }
    final orderModel = OrderModel(
        userId: AuthService.user!.uid,
        orderStatus: OrderStatus.pending,
        paymentMethod: paymentMethodGroupValue,
        deliveryAddress: AddressModel(
            streetAddress: userProvider.userModel!.address!.streetAddress,
            area: userProvider.userModel!.address!.area,
            city: userProvider.userModel!.address!.city,
            zipCode: userProvider.userModel!.address!.zipCode
        ),
        deliveryCharge: orderProvider.orderConstantsModel.deliveryCharge,
        discount: orderProvider.orderConstantsModel.discount,
        vat: orderProvider.orderConstantsModel.vat,
        grandTotal: orderProvider.getGrandTotal(cartProvider.getCartSubTotal()),
        orderDate: DateModel(
          timestamp: Timestamp.fromDate(DateTime.now()),
          day: DateTime.now().day,
          month: DateTime.now().month,
          year: DateTime.now().year,
        )
    );
    orderProvider.addOrder(orderModel, cartProvider.cartList)
    .then((_) {
      orderProvider.updateCategoryProductCount(
          cartProvider.cartList,
          context.read<ProductProvider>().categoryList)
          .then((_){
            orderProvider.clearAllCartItems(cartProvider.cartList)
                .then((_) =>{
                  Navigator.pushNamedAndRemoveUntil(context,
                      OrderSuccessfulPage.routeName, 
                      ModalRoute.withName(ProductPage.routeName))
            });
      });
    });
    // .catchError((error){
    //
    // });
  }
}
