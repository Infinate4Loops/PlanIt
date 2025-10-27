import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/grocery_item.dart';

class GroceryListProvider extends ChangeNotifier {
  GroceryListProvider() {
    _restoreFromStorage();
  }

  final List<GroceryItem> _items = <GroceryItem>[];

  UnmodifiableListView<GroceryItem> get items => UnmodifiableListView(_items);

  Future<void> addItem(String name) async {
    final item = GroceryItem(id: DateTime.now().microsecondsSinceEpoch.toString(), name: name);
    _items.insert(0, item);
    notifyListeners();
    await _persistToStorage();
  }

  Future<void> toggleItem(String id) async {
    final index = _items.indexWhere((e) => e.id == id);
    if (index == -1) return;
    _items[index] = _items[index].copyWith(isChecked: !_items[index].isChecked);
    notifyListeners();
    await _persistToStorage();
  }

  Future<void> removeItem(String id) async {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
    await _persistToStorage();
  }

  Future<void> clearAll() async {
    _items.clear();
    notifyListeners();
    await _persistToStorage();
  }

  Future<void> _persistToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = _items
          .map((e) => [e.id, e.name, e.isChecked ? '1' : '0'].join('\u241F'))
          .join('\u241E');
      await prefs.setString('grocery_items', raw);
    } catch (_) {
      // ignore persistence errors
    }
  }

  Future<void> _restoreFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString('grocery_items');
      if (raw == null || raw.isEmpty) return;
      final restored = raw.split('\u241E').where((s) => s.isNotEmpty).map((row) {
        final parts = row.split('\u241F');
        return GroceryItem(
          id: parts.elementAt(0),
          name: parts.elementAt(1),
          isChecked: parts.elementAt(2) == '1',
        );
      });
      _items
        ..clear()
        ..addAll(restored);
      notifyListeners();
    } catch (_) {
      // ignore restore errors
    }
  }
}