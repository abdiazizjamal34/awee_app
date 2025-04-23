import 'package:awee/screens/profile/profilr.dart';
import 'package:flutter/material.dart';
import 'package:awee/models/product.dart';
import 'package:awee/Services/product_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Future<List<Product>> futureProducts;
  bool isLoading = false;
  String? name;
  String? email;
  String? role;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // @override
  // void initState() {
  //   super.initState();
  //   futureProducts = ProductSerice().fetchProducts();
  // }

  @override
  void initState() {
    super.initState();
    _loadProducts();
    loadUserInfo();
  }

  Future<void> _handleRefresh() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 2000)); // custom delay
    futureProducts = ProductSerice().fetchProducts();
    setState(() => isLoading = false);
  }

  void loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'User';
      email = prefs.getString('email') ?? '';
      role = prefs.getString('role') ?? '';
    });
  }

  void _loadProducts() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 2000)); // 2 seconds delay
    futureProducts = ProductSerice().fetchProducts();
    setState(() => isLoading = false);
  }

  void _addOrEditProduct([Product? selectedProduct]) {
    if (selectedProduct != null) {
      // Prefill controllers for editing
      _nameController.text = selectedProduct.name;
      _idController.text = selectedProduct.sku;
      _priceController.text = selectedProduct.Price.toString();
      _stockController.text = selectedProduct.stock.toString();
      _categoryController.text = selectedProduct.category;
      _descriptionController.text = selectedProduct.description;
    } else {
      // Clear controllers for adding
      _nameController.clear();
      _idController.clear();
      _priceController.clear();
      _stockController.clear();
      _categoryController.clear();
      _descriptionController.clear();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(selectedProduct != null ? 'Edit Product' : 'Add Product'),
          content: _addProductForm(
            _nameController,
            _idController,
            _priceController,
            _stockController,
            _categoryController,
            _descriptionController,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed:
                  isLoading
                      ? null
                      : () async {
                        try {
                          setState(() => isLoading = true);
                          if (selectedProduct != null) {
                            await _updateProduct(selectedProduct.id);
                          } else {
                            await _addProduct();
                          }
                          setState(() {
                            futureProducts = ProductSerice().fetchProducts();
                          });
                          Navigator.of(context).pop();
                          _loadProducts();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("An error occurred: $e"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } finally {
                          setState(() => isLoading = false);
                        }
                      },
              child: Text(
                isLoading
                    ? (selectedProduct != null ? "Updating..." : "Adding...")
                    : (selectedProduct != null ? "Update" : "Add"),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addProduct() async {
    final result = await ProductSerice().addProduct({
      "name": _nameController.text,
      "sku": _idController.text,
      "price": double.tryParse(_priceController.text) ?? 0,
      "stock": int.tryParse(_stockController.text) ?? 0,
      "description": _descriptionController.text,
      "category": _categoryController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _updateProduct(String productId) async {
    final result = await ProductSerice().updateProduct(productId, {
      "name": _nameController.text,
      "sku": _idController.text,
      "price": double.tryParse(_priceController.text) ?? 0,
      "stock": int.tryParse(_stockController.text) ?? 0,
      "description": _descriptionController.text,
      "category": _categoryController.text,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 112, 127, 156),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [profile(name, email), const SizedBox(height: 8)],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => _addOrEditProduct(),
                  child: const Text('Add Product'),
                ),
              ],
            ),

            const SizedBox(height: 16),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _handleRefresh,
                color: Colors.white,
                backgroundColor: const Color.fromARGB(255, 27, 30, 40),
                displacement: 50,
                strokeWidth: 3,
                child:
                    isLoading
                        ? buildShimmerPlaceholder()
                        : FutureBuilder<List<Product>>(
                          future: futureProducts,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text('No products found.'),
                              );
                            }

                            final products = snapshot.data!;
                            return ListView.separated(
                              itemCount: products.length,
                              separatorBuilder:
                                  (context, index) =>
                                      const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      20,
                                      24,
                                      33,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(
                                            255,
                                            221,
                                            218,
                                            218,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Stock: ${product.stock} | Price: \$${product.Price}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          TextButton.icon(
                                            onPressed:
                                                () =>
                                                    _addOrEditProduct(product),
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.yellow,
                                            ),
                                            label: const Text(
                                              'Edit',
                                              style: TextStyle(
                                                color: Colors.yellow,
                                              ),
                                            ),
                                          ),
                                          TextButton.icon(
                                            onPressed: () async {
                                              final result =
                                                  await ProductSerice()
                                                      .deleteProduct(
                                                        product.id,
                                                      );
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    result['message'],
                                                  ),
                                                  backgroundColor:
                                                      result['success']
                                                          ? Colors.green
                                                          : Colors.red,
                                                ),
                                              );
                                              setState(() {
                                                futureProducts =
                                                    ProductSerice()
                                                        .fetchProducts();
                                              });
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.redAccent,
                                            ),
                                            label: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.redAccent,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildShimmerPlaceholder() {
  return ListView.separated(
    itemCount: 6,
    separatorBuilder: (_, __) => const SizedBox(height: 16),
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: const Color.fromARGB(255, 22, 32, 53),
        highlightColor: const Color.fromARGB(255, 53, 64, 79),
        child: Container(
          height: 80,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 51, 63, 87),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    },
  );
}

Widget _addProductForm(
  TextEditingController nameController,
  TextEditingController idController,
  TextEditingController priceController,
  TextEditingController stockController,
  TextEditingController categoryController,
  TextEditingController descriptionController,
) {
  return SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Product Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: idController,
          decoration: const InputDecoration(
            labelText: 'Product ID',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: priceController,
          decoration: const InputDecoration(
            labelText: 'Price',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: stockController,
          decoration: const InputDecoration(
            labelText: 'Stock',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: categoryController,
          decoration: const InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    ),
  );
}
