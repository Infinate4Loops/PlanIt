class GroceryItem {
  GroceryItem({required this.id, required this.name, this.isChecked = false});

  final String id;
  final String name;
  final bool isChecked;

  GroceryItem copyWith({String? id, String? name, bool? isChecked}) {
    return GroceryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}