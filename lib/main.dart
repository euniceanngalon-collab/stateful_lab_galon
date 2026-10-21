
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CartScreen(),
    ),
  );
}

// Stores the information of each shopping item.
class CartItem {
  String name;
  double price;
  int quantity;
  bool gotIt;

  CartItem({
    required this.name,
    required this.price,
    required this.quantity,
    this.gotIt = false,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> _items = [];

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _priceController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _items.add(
      CartItem(
        name: 'Rice',
        price: 60.00,
        quantity: 2,
      ),
    );

    _items.add(
      CartItem(
        name: 'Eggs',
        price: 8.00,
        quantity: 12,
      ),
    );

    _items.add(
      CartItem(
        name: 'Milk',
        price: 95.00,
        quantity: 1,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  // Increase quantity, with a maximum of 99.
  void _increase(int index) {
    if (_items[index].quantity < 99) {
      setState(() {
        _items[index].quantity++;
      });
    }
  }

  // Decrease quantity, with a minimum of 1.
  void _decrease(int index) {
    if (_items[index].quantity > 1) {
      setState(() {
        _items[index].quantity--;
      });
    }
  }

  // Check or uncheck an item.
  void _toggle(int index, bool? checked) {
    setState(() {
      _items[index].gotIt = checked ?? false;
    });
  }

  // Calculate the total using the current items and quantities.
  double get _total {
    double total = 0;

    for (CartItem item in _items) {
      total += item.price * item.quantity;
    }

    return total;
  }

  // Count the checked items.
  int get _gotItCount {
    return _items.where((item) => item.gotIt).length;
  }

  // Add a new item after validating the input.
  void _addItem() {
    String name = _nameController.text.trim();
    double? price = double.tryParse(
      _priceController.text.trim(),
    );

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an item name.'),
        ),
      );
      return;
    }

    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid price greater than 0.'),
        ),
      );
      return;
    }

    setState(() {
      _items.add(
        CartItem(
          name: name,
          price: price,
          quantity: 1,
        ),
      );

      _nameController.clear();
      _priceController.clear();
    });
  }

  // Remove checked items completely from the cart.
  void _clearChecked() {
    setState(() {
      _items.removeWhere((item) => item.gotIt == true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shopping Cart'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shopping Items',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: _items.isEmpty
                    ? const Center(
                        child: Text('Your cart is empty.'),
                      )
                    : ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          return CartItemTile(
                            item: _items[index],
                            onIncrease: () => _increase(index),
                            onDecrease: () => _decrease(index),
                            onToggle: (checked) {
                              _toggle(index, checked);
                            },
                          );
                        },
                      ),
              ),

              const Divider(),

              Text(
                'Items: ${_items.length}  |  Got it: $_gotItCount',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Total: PHP ${_total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Add New Item',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item name',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: _priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixText: 'PHP ',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _addItem,
                      icon: const Icon(Icons.add),
                      label: const Text('Add'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearChecked,
                      child: const Text('Clear checked'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Displays one item. Changes are handled by CartScreen.
class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final ValueChanged<bool?> onToggle;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 6,
        ),
        child: Row(
          children: [
            Checkbox(
              value: item.gotIt,
              onChanged: onToggle,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: item.gotIt
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),

                  Text(
                    'PHP ${item.price.toStringAsFixed(2)} each',
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed:
                  item.quantity > 1 ? onDecrease : null,
              icon: const Icon(
                Icons.remove_circle_outline,
              ),
            ),

            Text(
              '${item.quantity}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            IconButton(
              onPressed:
                  item.quantity < 99 ? onIncrease : null,
              icon: const Icon(
                Icons.add_circle_outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
