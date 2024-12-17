class Item {
  final int id;
  String name;
  Item({required this.id, required this.name});
  // Factory method to convert JSON to Item
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
    );
  }
  // CopyWith method for immutability
  Item copyWith({int? id, String? name}) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
