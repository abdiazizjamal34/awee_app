import 'package:awee/Services/product_service.dart';
import 'package:awee/screens/custemer/data/custemer_repositery.dart';
import 'package:awee/screens/order_mngmnt/model/order.dart';
import 'package:awee/screens/order_mngmnt/presentation/bloc/order_bloc.dart';
import 'package:awee/screens/order_mngmnt/presentation/bloc/order_event.dart';
import 'package:awee/screens/products/models/product.dart';
import 'package:awee/wideget/success_animation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customerSearchController =
      TextEditingController();
  final TextEditingController _productSearchController =
      TextEditingController();

  String? selectedCustomerId;
  List<Map<String, dynamic>> selectedProducts = [];
  bool isLoading = false; // ✅ Add loading flag

  @override
  void initState() {
    super.initState();
    loadData();
  }

  List<Customer> customers = [];
  List<Product> products = [];

  List<Customer> filteredCustomers = [];
  List<Product> filteredProducts = [];

  void loadData() async {
    try {
      final fetchedCustomers = await CustomerRepository().fetchCustomers();
      final fetchedProducts = await ProductSerice().fetchProducts();
      setState(() {
        customers = fetchedCustomers;
        products = fetchedProducts;
        filteredCustomers = customers;
        filteredProducts = products;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load data: $e')));
    }
  }

  void filterCustomers(String query) {
    final filtered =
        customers
            .where(
              (customer) =>
                  customer.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
    setState(() {
      filteredCustomers = filtered;
    });
  }

  void filterProducts(String query) {
    final filtered =
        products
            .where(
              (product) =>
                  product.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
    setState(() {
      filteredProducts = filtered;
    });
  }

  Future<void> createOrder() async {
    if (!_formKey.currentState!.validate() ||
        selectedCustomerId == null ||
        selectedProducts.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final orderData = {
        "customerId": selectedCustomerId,
        "products":
            selectedProducts
                .map((p) => {"productId": p['id'], "quantity": p['quantity']})
                .toList(),
      };

      context.read<OrderBloc>().add(CreateOrder(orderData));

      await Future.delayed(const Duration(seconds: 1)); // Optional UX wait

      if (mounted) {
        setState(() {
          isLoading = false;
        });

        // ✅ Clear fields after success
        selectedCustomerId = null;
        selectedProducts.clear();
        _customerSearchController.clear();
        _productSearchController.clear();
        filteredCustomers = customers;
        filteredProducts = products;

        // ✅ Show Success Animation instead of normal dialog
        showDialog(
          context: context,
          builder: (_) => const SuccessAnimationDialog(),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      if (mounted) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Error'),
                content: Text('Failed to create order. Error: $e'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      }
    }
  }

  void addProduct(Map<String, dynamic> product) {
    setState(() {
      selectedProducts.add({
        'id': product['id'],
        'name': product['name'],
        'quantity': 1,
      });
    });
  }

  void removeProduct(int index) {
    setState(() {
      selectedProducts.removeAt(index);
    });
  }

  void updateProductQuantity(int index, int quantity) {
    setState(() {
      selectedProducts[index]['quantity'] = quantity;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Order')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Select Customer'),

              // DropdownButtonFormField<String>(
              //   value: selectedCustomerId,
              //   hint: const Text(
              //     'Choose a Customer',
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   items:
              //       customers.map((customer) {
              //         return DropdownMenuItem(
              //           value: customer.id,
              //           child: Text(
              //             customer.name,
              //             style: TextStyle(
              //               color: const Color.fromARGB(255, 0, 0, 0),
              //             ),
              //           ),
              //         );
              //       }).toList(),
              //   onChanged: (value) {
              //     setState(() {
              //       selectedCustomerId = value;
              //     });
              //   },
              //   validator:
              //       (value) => value == null ? 'Select a customer' : null,
              // ),
              TextField(
                controller: _customerSearchController,
                decoration: const InputDecoration(
                  hintText: 'Search Customer',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: filterCustomers, // 🔥
              ),
              DropdownButtonFormField<String>(
                value: selectedCustomerId,
                hint: const Text('Choose a Customer'),
                items:
                    filteredCustomers.map((customer) {
                      return DropdownMenuItem(
                        value: customer.id,
                        child: Text(customer.name),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCustomerId = value;
                  });
                },
                validator:
                    (value) => value == null ? 'Select a customer' : null,
              ),

              const SizedBox(height: 10),
              const SizedBox(height: 20),
              const Text('Select Products'),
              TextField(
                controller: _productSearchController,
                decoration: const InputDecoration(
                  hintText: 'Search Product',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: filterProducts, // 🔥
              ),
              const SizedBox(height: 10),
              ...filteredProducts.map((product) {
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Price: \$${product.Price}'),
                  trailing: ElevatedButton(
                    onPressed:
                        () => addProduct({
                          'id': product.id,
                          'name': product.name,
                          'price': product.Price,
                        }),
                    child: const Text('Add'),
                  ),
                );
              }).toList(),

              const SizedBox(height: 20),
              const Text('Selected Products'),
              const SizedBox(height: 10),
              ...selectedProducts.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> product = entry.value;
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Row(
                    children: [
                      const Text('Quantity: '),
                      SizedBox(
                        width: 50,
                        child: TextFormField(
                          initialValue: product['quantity'].toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            final qty = int.tryParse(value) ?? 1;
                            updateProductQuantity(index, qty);
                          },
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => removeProduct(index),
                  ),
                );
              }).toList(),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: isLoading ? null : createOrder,
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Submit Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
