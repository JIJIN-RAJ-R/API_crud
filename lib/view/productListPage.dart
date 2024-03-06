import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<dynamic>> _products;

  final String httpUrl = 'https://crudcrud.com/api/d6d41bd1aed74c99a6e821805e5aea5d/unicorns';

  Future<List<dynamic>> fetchProducts() async {
    final response = await http.get(Uri.parse(httpUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> addProduct(String title, double price, String description,
      String category, String image) async {
    try {
      final response = await http.post(
        Uri.parse(httpUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': title,
          'price': price,
          'description': description,
          'category': category,
          'image': image,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          _products = fetchProducts();
        });
      } else {
        throw Exception('Failed to add product: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to add product: $error');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      final response = await http.delete(Uri.parse('$httpUrl/$productId'));
      if (response.statusCode == 200) {
        setState(() {
          _products = fetchProducts();
        });
      } else {
        throw Exception('Failed to delete product: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to delete product: $error');
    }
  }

  Future<void> updateProduct(String productId, String title, double price,
      String description, String category, String image) async {
    try {
      final response = await http.put(
        Uri.parse('$httpUrl/$productId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'title': title,
          'price': price,
          'description': description,
          'category': category,
          'image': image,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _products = fetchProducts();
        });
      } else {
        throw Exception('Failed to update product: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to update product: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _products = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'API_Crud',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var product = snapshot.data![index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(product['image'] ?? ''),
                    ),
                    title: Text(
                      product['title'] ?? '',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text('\$${product['price'] ?? ''}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditProductDialog(context, product);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            deleteProduct(product['_id'] ?? '');
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProductDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddProductDialog(BuildContext context) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    TextEditingController imageController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                addProduct(
                  titleController.text,
                  double.tryParse(priceController.text) ?? 0.0,
                  descriptionController.text,
                  categoryController.text,
                  imageController.text,
                ).then((_) {
                  Navigator.of(context).pop();
                }).catchError((error) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: Text('Failed to add product: $error'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                });
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditProductDialog(
      BuildContext context, Map<String, dynamic> product) async {
    TextEditingController titleController =
        TextEditingController(text: product['title']);
    TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    TextEditingController descriptionController =
        TextEditingController(text: product['description']);
    TextEditingController categoryController =
        TextEditingController(text: product['category']);
    TextEditingController imageController =
        TextEditingController(text: product['image']);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                  ),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                updateProduct(
                  product['_id'] ?? '',
                  titleController.text,
                  double.tryParse(priceController.text) ?? 0.0,
                  descriptionController.text,
                  categoryController.text,
                  imageController.text,
                ).then((_) {
                  Navigator.of(context).pop();
                }).catchError((error) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: Text('Failed to update product: $error'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                });
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
