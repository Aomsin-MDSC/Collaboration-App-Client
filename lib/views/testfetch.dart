import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controllers/testfetchcontroller.dart'; // Update the import path if needed
import '../models/testmodel.dart'; // Update the import path if needed

class TestFetch extends StatefulWidget {
  const TestFetch({super.key});

  @override
  State<TestFetch> createState() => _TestFetchState();
}

class _TestFetchState extends State<TestFetch> {
  @override
  void initState() {
    // Initialize the ProductController
    Get.put(ProductController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Test Fetch"),
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (productController.products.isEmpty) {
          return Center(child: Text('No products found'));
        } else {
          return ListView.builder(
            primary: false,
            itemCount: productController.products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: productController.products[index]);
            },
          );
        }
      }),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                product.image,
                fit: BoxFit.cover,
              ),
            ),
            ListTile(
              title: Text(product.title),
              subtitle: Text('${product.price} \$'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.orange),
                  Text('${product.rating}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
