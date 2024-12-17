// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_event.dart';
import 'bloc_state.dart';
import 'bloc_use.dart';
import 'model.dart';
import 'network_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final NetworkService networkService = NetworkService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Example',
      debugShowCheckedModeBanner: false,
      home: BlocProvider<ItemBloc>(
        create: (context) => ItemBloc(networkService)..add(FetchItems()),
        child: ItemScreen(),
      ),
    );
  }
}

class ItemScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Item List")),
      body: BlocBuilder<ItemBloc, ItemState>(
        builder: (context, state) {
          if (state is ItemLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ItemLoaded || state is ItemUpdated) {
            final items = (state is ItemLoaded)
                ? state.items
                : (state is ItemUpdated)
                ? state.items
                : [];

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.name),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _showUpdateDialog(context, item);
                    },
                  ),
                );
              },
            );
          } else if (state is ItemError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: Text('No data available'));
        },
      ),
    );
  }

  // Method to show update dialog for item
  Future<void> _showUpdateDialog(BuildContext context, Item item) async {
    final controller = TextEditingController(text: item.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Item'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: 'New title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text('Update'),
          ),
        ],
      ),
    );
    // Check if the new name is valid (non-empty)
    if (newName != null && newName.isNotEmpty) {
      // Dispatch event to BLoC to update the item
      context.read<ItemBloc>().add(UpdateItem(item.id, newName));
    }
  }

}
