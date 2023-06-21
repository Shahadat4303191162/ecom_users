import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecom_users/pages/cart_page.dart';
import 'package:ecom_users/providers/cat_provider.dart';
import 'package:ecom_users/widgets/main_drawer.dart';
import 'package:ecom_users/widgets/product_item.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/product_porvider.dart';
import '../utils/constants.dart';

class ProductPage extends StatefulWidget {
  static const String routeName = '/productPage';

  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}



class _ProductPageState extends State<ProductPage> {

  int? chipValue = 0;

  @override
  void didChangeDependencies() {
    Provider.of<ProductProvider>(context,listen: false).getAllProducts();
    Provider.of<ProductProvider>(context,listen: false).getAllCategories();
    Provider.of<CartProvider>(context,listen: false).getCartByUser();
    Provider.of<ProductProvider>(context,listen: false)
        .getAllFeaturedProducts();
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, CartPage.routeName),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_cart,size: 30,),
                  Positioned(
                    top: -4,
                    left: -4,
                    child: Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle
                      ),
                      child: FittedBox(child: Consumer<CartProvider>(
                        builder: (context, value, child) =>
                            Text('${value.totalItemsInCart}'),
                      )),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) =>
            Column(
          children: [
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.categoryNameList.length,
                itemBuilder: (context,index){
                  final catName = provider.categoryNameList[index];
                  return Padding(
                      padding: const EdgeInsets.all(4.0),
                    child: ChoiceChip(
                      labelStyle: TextStyle(
                        color: chipValue == index? Colors.white:Colors.black
                      ),
                      selectedColor: Theme.of(context).primaryColor,
                      label: Text(catName),
                      selected: chipValue == index,
                      onSelected: ((value){
                        setState(() {
                          chipValue = value? index : null;
                        });
                        if(chipValue != null && chipValue != 0){
                          provider.getAllProductsByCategory(catName);
                        }else if(chipValue == 0){
                          provider.getAllProducts();
                        }
                      }),
                    ),

                  );
                }
              ),
            ),
            const Text('Featured Products',style: TextStyle(fontSize: 18),),
            const Divider(height: 1,),
            CarouselSlider(
                items: provider.featuredProductList.map((e) =>
                Container(
                  color: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.all(1),
                  child: Stack(
                    children: [
                      FadeInImage.assetNetwork(
                        fadeInDuration: const Duration(seconds: 2),
                        fadeInCurve: Curves.bounceInOut,
                        placeholder: 'images/placeholder.jpg',
                        image: e.imageUrl!,
                        width: double.maxFinite,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),

                )).toList(),
                options: CarouselOptions(
                  height: 250.0,
                  aspectRatio: 16/9,
                  viewportFraction: 0.8,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  //onPageChanged: callbackFunction,
                  scrollDirection: Axis.horizontal,

                )),
            provider.productList.isEmpty
                ? const Center(
                    child: Text(
                      'NO Item found',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : Expanded(
                  child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          childAspectRatio: 0.555
                      ),
                      itemBuilder: (context,index){
                        final product = provider.productList[index];
                        return ProductItem(productModel: product,);
                      },
                      itemCount: provider.productList.length,
                    ),
                ),
          ],
        ),
      ),
    );
  }
}
