import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final tableName = 'products';
  final client = Supabase.instance.client;
  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
      ),
      body: _pageWidget(),
      backgroundColor: Colors.white,
      floatingActionButton: _buttonWidget(),
    );
  }

  Widget _pageWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.symmetric(
        vertical: 20.0,
        horizontal: 20.0,
      ),
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: client.from(tableName).stream(primaryKey: ['id']),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final products = snapshot.data;

          if (products == null || products.isEmpty) {
            return const Center(
              child: Text('No data'),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              var item = products[index];

              return ListTile(
                title: Text(item['name'] ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blueAccent,
                      ),
                      onPressed: () => _showDialogFunction(
                        title: 'Edit produc',
                        function: () => _updateProduct(item['id'].toString()),
                        inputValue: item['name'] ?? '',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => _deleteProduct(item['id'].toString()),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buttonWidget() {
    return FloatingActionButton(
      onPressed: () => _showDialogFunction(
        title: 'Add produc',
        function: _saveProduct,
      ),
      child: const Icon(Icons.add),
    );
  }

  void _showDialogFunction({
    required String title,
    required VoidCallback function,
    String? inputValue,
  }) {
    if (inputValue != null && inputValue.isNotEmpty) {
      inputController.text = inputValue;
    } else {
      inputController.clear();
    }

    showDialog(
      context: context,
      builder: ((context) {
        return SimpleDialog(
          title: Text(title),
          contentPadding: const EdgeInsets.all(20.0),
          children: [
            TextFormField(
              controller: inputController,
            ),
            ElevatedButton(
              onPressed: () => function(),
              child: const Text('Save'),
            ),
          ],
        );
      }),
    );
  }

  void _saveProduct() async {
    try {
      await client.from(tableName).insert(
        {'name': inputController.text},
      );
      await Future.delayed(const Duration(milliseconds: 200));
      inputController.clear();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (err) {
      // ignore: avoid_print
      print(err.toString());
    }
  }

  void _deleteProduct(String id) async {
    try {
      await client.from(tableName).delete().eq('id', id);
    } catch (err) {
      // ignore: avoid_print
      print(err.toString());
    }
  }

  void _updateProduct(String id) async {
    try {
      await client.from(tableName).update(
        {'name': inputController.text},
      ).eq('id', id);
      await Future.delayed(const Duration(milliseconds: 200));
      inputController.clear();
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (err) {
      // ignore: avoid_print
      print(err.toString());
    }
  }
}
