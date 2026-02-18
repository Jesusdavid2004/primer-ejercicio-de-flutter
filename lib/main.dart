import 'package:flutter/material.dart';

void main() => runApp(const SurgicalStoreApp());

class SurgicalStoreApp extends StatefulWidget {
  const SurgicalStoreApp({super.key});

  @override
  State<SurgicalStoreApp> createState() => _SurgicalStoreAppState();
}

class _SurgicalStoreAppState extends State<SurgicalStoreApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Surgical Instrument Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const StorePage(),
    );
  }
}

class Product {
  final String name;
  final int priceCop;
  final int stock;

  const Product({
    required this.name,
    required this.priceCop,
    required this.stock,
  });
}

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final List<Product> _catalog = [
    const Product(name: 'Scalpel #15', priceCop: 12000, stock: 25),
    const Product(name: 'Kelly Clamp', priceCop: 38000, stock: 12),
    const Product(name: 'Mayo Scissors', priceCop: 45000, stock: 10),
    const Product(name: 'Needle Holder', priceCop: 52000, stock: 8),
  ];

  final List<Product> _cart = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  int get cartTotalCop => _cart.fold(0, (sum, p) => sum + p.priceCop);

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void addToCart(Product product) {
    setState(() {
      _cart.add(product);
    });
  }

  void removeFromCart(int index) {
    setState(() {
      _cart.removeAt(index);
    });
  }

  void openAddProductDialog() {
    _nameController.clear();
    _priceController.clear();
    _stockController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add new product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price (COP)'),
              ),
              TextField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final priceCop = int.tryParse(_priceController.text.trim());
                final stock = int.tryParse(_stockController.text.trim());

                if (name.isEmpty || priceCop == null || stock == null) return;

                setState(() {
                  _catalog.add(
                    Product(name: name, priceCop: priceCop, stock: stock),
                  );
                });

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Surgical Instrument Store'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('Cart: ${_cart.length}')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddProductDialog,
        child: const Icon(Icons.add),
      ),
      body: Row(
        children: [
          // Catalog
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Catalog', style: TextStyle(fontSize: 18)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _catalog.length,
                    itemBuilder: (context, index) {
                      final product = _catalog[index];
                      return ListTile(
                        title: Text(product.name),
                        subtitle: Text(
                          'COP ${product.priceCop} • Stock: ${product.stock}',
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => addToCart(product),
                          child: const Text('Add'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Cart
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    'Cart • Total: COP $cartTotalCop',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Expanded(
                  child: _cart.isEmpty
                      ? const Center(child: Text('Cart is empty'))
                      : ListView.builder(
                          itemCount: _cart.length,
                          itemBuilder: (context, index) {
                            final product = _cart[index];
                            return ListTile(
                              title: Text(product.name),
                              subtitle: Text('COP ${product.priceCop}'),
                              trailing: IconButton(
                                onPressed: () => removeFromCart(index),
                                icon: const Icon(Icons.delete),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
