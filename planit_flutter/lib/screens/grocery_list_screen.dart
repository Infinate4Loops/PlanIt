import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/grocery_list_provider.dart';
import '../models/grocery_item.dart';

class GroceryListScreen extends StatelessWidget {
  const GroceryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<GroceryListProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        actions: [
          IconButton(
            onPressed: provider.items.isEmpty ? null : () => provider.clearAll(),
            icon: const Icon(Icons.delete_sweep_outlined),
            tooltip: 'Clear all',
          )
        ],
      ),
      body: Column(
        children: [
          const _AddItemField(),
          const Divider(height: 1),
          Expanded(
            child: provider.items.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    itemCount: provider.items.length,
                    itemBuilder: (context, index) {
                      final GroceryItem item = provider.items[index];
                      return Dismissible(
                        key: ValueKey(item.id),
                        background: Container(color: Colors.red.withOpacity(0.2)),
                        onDismissed: (_) => provider.removeItem(item.id),
                        child: CheckboxListTile(
                          value: item.isChecked,
                          onChanged: (_) => provider.toggleItem(item.id),
                          title: Text(item.name),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _AddItemField extends StatefulWidget {
  const _AddItemField();

  @override
  State<_AddItemField> createState() => _AddItemFieldState();
}

class _AddItemFieldState extends State<_AddItemField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Add an item',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _submit(context),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () => _submit(context),
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _submit(BuildContext context) {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<GroceryListProvider>().addItem(text);
    _controller.clear();
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.shopping_cart_outlined, size: 56),
            SizedBox(height: 12),
            Text('Your grocery list is empty'),
          ],
        ),
      ),
    );
  }
}