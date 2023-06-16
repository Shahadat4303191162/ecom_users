import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/product_porvider.dart';
import '../utils/constants.dart';

class ProductPage extends StatelessWidget {
  static const String routeName = '/productPage';

  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) => provider.productList.isEmpty
            ? const Center(
                child: Text(
                  'NO Item found',
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: provider.productList.length,
                itemBuilder: (context, index) {
                  final product = provider.productList[index];
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(product.imageUrl!),
                      ),
                      title: Text(product.name!),
                      trailing: Text(
                        '$currencysymbol ${product.salesPrice}',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
