import 'package:flutter/material.dart';
import 'package:awee/models/product.dart';
import 'package:awee/Services/product_service.dart';

class Product_Screen extends StatefulWidget {
  @override
  _Product_ScreenState createState() => _Product_ScreenState();
}

class _Product_ScreenState extends State<Product_Screen> {
  late Future<List<Product>> futureProducts;
  bool isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // final TextEditingController _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureProducts = ProductSerice().fetchProducts();
  }

  void addProduct() async {
    setState(() => isLoading = true); // Set isLoading to true when starting

    final result = await ProductSerice().addProduct({
      "name": _nameController.text,
      "sku": _idController.text,
      "price": double.tryParse(_priceController.text) ?? 0,
      "stock": int.tryParse(_stockController.text) ?? 0,
      "description": _descriptionController.text,
      "category": _categoryController.text,
    });

    setState(() => isLoading = false); // Set isLoading to false when done

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );

    if (result['success']) {
      Navigator.pop(context); // Go back to the product list
    }
  }

  void _addProducts() {
    // Handle product submission
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: _addProduct(
            _nameController,
            _idController,
            _priceController,
            _stockController,
            _categoryController,
            _descriptionController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: isLoading ? null : addProduct,
              child: Text(isLoading ? "Adding..." : "Add Product"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // IconButton(
                //   icon: const Icon(Icons.plus_one_rounded),
                //   onPressed: _addProducts,
                // ),
                ElevatedButton(
                  onPressed: _addProducts,
                  child: Text('Add Product'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products found.'));
                  }

                  final products = snapshot.data!;

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final p = products[index];
                      return ListTile(
                        title: Text(
                          p.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          "Stock: ${p.stock} | Price: \$${p.Price}",
                        ),
                        trailing: Text(p.category),
                      );
                    },
                  );

                  // return ListView.builder(
                  //   itemCount: products.length,
                  //   itemBuilder: (context, index) {
                  //     final p = products[index];
                  //     return ListTile(
                  //       title: Text(
                  //         p.name,
                  //         style: TextStyle(
                  //           fontSize: 20,
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //       subtitle: Text("Stock: ${p.stock} | Price: \$${p.Price}"),
                  //       trailing: Text(p.category),
                  //     );
                  //   },
                  // );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _addProduct(
  TextEditingController nameController,
  TextEditingController idController,
  TextEditingController priceController,
  TextEditingController stockController,
  TextEditingController categoryController,
  TextEditingController descriptionController,
) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(height: 50),
      // Image.asset('assets/welcome.png'),
      // Text(
      //   'Welcome back!',
      //   style: TextStyle(fontSize: 24, color: Colors.white),
      // ),
      SizedBox(height: 20),
      TextField(
        controller: nameController,
        decoration: InputDecoration(
          labelText: 'Product Name',
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 20),
      TextField(
        controller: idController,
        decoration: InputDecoration(
          labelText: 'Product ID',
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 20),
      TextField(
        controller: priceController,
        decoration: InputDecoration(
          labelText: 'Price',
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 20),
      TextField(
        controller: stockController,
        decoration: InputDecoration(
          labelText: 'Stock',
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 20),
      TextField(
        controller: categoryController,
        decoration: InputDecoration(
          labelText: 'category',
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 20),
      TextField(
        controller: descriptionController,
        decoration: InputDecoration(
          labelText: 'description',
          border: OutlineInputBorder(),
        ),
      ),
      SizedBox(height: 20),
      // ElevatedButton(
      //   onPressed: () {
      //     // Handle product submission
      //   },
      //   child: Text('Submit Product'),
      // ),
    ],
  );
}
