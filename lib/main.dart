
import 'package:flutter/material.dart';

void main() {
  runApp(const QuickCartApp());
}

class CartItem {
  final String name;
  final double price;
  int quantity;
  bool gotIt;

  CartItem({
    required this.name,
    required this.price,
    this.quantity = 1,
    this.gotIt = false,
  });
}

class QuickCartApp extends StatelessWidget {
  const QuickCartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickCart',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF167D67),
        scaffoldBackgroundColor: const Color(0xFFF4F7F5),
      ),
      home: const CartScreen(),
    );
  }
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

  String? _nameError;
  String? _priceError;

  @override
  void initState() {
    super.initState();

    // Load sample groceries when the screen is first created.
    _items.addAll([
      CartItem(name: 'Rice', price: 60.00, quantity: 2),
      CartItem(name: 'Eggs', price: 8.00, quantity: 12),
      CartItem(name: 'Milk', price: 95.00),
    ]);
  }

  // Calculate the current cost of all items.
  double get _total {
    return _items.fold(
      0.0,
      (sum, item) => sum + item.price * item.quantity,
    );
  }

  int get _checkedCount =>
      _items.where((item) => item.gotIt).length;

  void _increase(int index) {
    if (_items[index].quantity >= 99) return;

    setState(() {
      _items[index].quantity++;
    });
  }

  void _decrease(int index) {
    if (_items[index].quantity <= 1) return;

    setState(() {
      _items[index].quantity--;
    });
  }

  void _toggle(int index, bool value) {
    setState(() {
      _items[index].gotIt = value;
    });
  }

  void _addItem() {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());

    setState(() {
      _nameError = name.isEmpty
          ? 'Please enter an item name'
          : null;

      _priceError = price == null || price <= 0
          ? 'Enter a price greater than 0'
          : null;

      if (_nameError != null || _priceError != null) {
        return;
      }

      _items.add(
        CartItem(name: name, price: price!),
      );

      _nameController.clear();
      _priceController.clear();
      _nameError = null;
      _priceError = null;
    });
  }

  void _clearChecked() {
    final count = _checkedCount;

    setState(() {
      _items.removeWhere((item) => item.gotIt);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count checked item(s) removed'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    // Release both controllers when this screen is removed.
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QuickCart',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF167D67),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'My Shopping List',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF204A3D),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Keep track of your groceries and budget.',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 16),

                  // Summary updates whenever cart state changes.
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDDEFE7),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Items: ${_items.length}'),
                            Text('Got it: $_checkedCount'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Total: PHP ${_total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF14634F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _items.isEmpty
                  ? const Center(
                      child: Text('Your shopping list is empty.'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        return CartItemTile(
                          key: ValueKey(_items[index]),
                          item: _items[index],
                          onIncrease: () => _increase(index),
                          onDecrease: () => _decrease(index),
                          onToggle: (value) =>
                              _toggle(index, value),
                        );
                      },
                    ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFE0E7E3)),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Add a new item',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Item name',
                      errorText: _nameError,
                      prefixIcon: const Icon(Icons.shopping_bag_outlined),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _priceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Price in PHP',
                      errorText: _priceError,
                      prefixIcon: const Icon(Icons.payments_outlined),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _addItem,
                          icon: const Icon(Icons.add),
                          label: const Text('Add item'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      OutlinedButton(
                        onPressed: _checkedCount == 0
                            ? null
                            : _clearChecked,
                        child: const Text('Clear checked'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final ValueChanged<bool> onToggle;

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
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 9,
        ),
        child: Row(
          children: [
            Checkbox(
              value: item.gotIt,
              onChanged: (value) {
                if (value != null) onToggle(value);
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      decoration: item.gotIt
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: item.gotIt
                          ? Colors.grey
                          : const Color(0xFF263C34),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'PHP ${item.price.toStringAsFixed(2)} each',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Decrease quantity',
              onPressed: item.quantity <= 1 ? null : onDecrease,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(
              '${item.quantity}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              tooltip: 'Increase quantity',
              onPressed: item.quantity >= 99 ? null : onIncrease,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ),
    );
  }
}
