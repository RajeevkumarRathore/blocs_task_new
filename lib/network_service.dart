import 'dart:convert';
import 'package:http/http.dart' as http;
import 'model.dart'; // The model for Item
class NetworkService {
  final String apiUrl = "https://jsonplaceholder.typicode.com/users"; // Example API URL
  // Fetch items from the API
  Future<List<Item>> fetchItems() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<Item> items = (json.decode(response.body) as List)
            .map((data) => Item.fromJson(data))
            .toList();
        return items;
      } else {
        throw Exception('Failed to load items');
      }
    } catch (e) {
      throw Exception('Failed to load items: $e');
    }
  }
  // Update item on the API
  Future<Item> updateItem(int itemId, String newName) async {
    try {
      final response = await http.put(
        Uri.parse("$apiUrl/$itemId"),
        body: json.encode({'name': newName}),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        return Item.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to update item');
      }
    } catch (e) {
      throw Exception('Failed to update item: $e');
    }
  }
}
