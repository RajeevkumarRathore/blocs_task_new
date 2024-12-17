/*
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_event.dart';  // Import ItemEvent
import 'bloc_state.dart';  // Import ItemState
import 'network_service.dart'; // Import network service
import 'model.dart'; // Import model
class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final NetworkService networkService;
  ItemBloc(this.networkService) : super(ItemInitial()) {
    // FetchItems event to load items
    on<FetchItems>((event, emit) async {
      emit(ItemLoading());
      try {
        final items = await networkService.fetchItems();
        emit(ItemLoaded(items));
      } catch (e) {
        emit(ItemError("Failed to load items: $e"));
      }
    });
    // UpdateItem event to handle item update
    on<UpdateItem>((event, emit) async {
      if (state is ItemLoaded) {
        final currentState = state as ItemLoaded;

        // Optimistic update - update item locally in the list
        List<Item> updatedItems = List.from(currentState.items);
        int index = updatedItems.indexWhere((item) => item.id == event.itemId);
        if (index != -1) {
          updatedItems[index].name = event.newName;
        }
        // Emit the updated list locally (optimistic UI update)
        emit(ItemUpdated(updatedItems));
        try {
          // Call network service to update the item on the server
          final updatedItem = await networkService.updateItem(event.itemId, event.newName);
          // Replace the item in the list with the updated item from the backend
          int updatedIndex = updatedItems.indexWhere((item) => item.id == event.itemId);
          if (updatedIndex != -1) {
            updatedItems[updatedIndex] = updatedItem;
          }
          // Emit the final updated list after the backend update
          emit(ItemUpdated(updatedItems));
        } catch (e) {
          // If the update fails, emit an error state
          emit(ItemError("Failed to update item: $e"));
        }
      }
    });
  }
}
*/
// bloc_use.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_event.dart';
import 'bloc_state.dart';
import 'network_service.dart';
import 'model.dart';

// bloc_use.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_event.dart';
import 'bloc_state.dart';
import 'network_service.dart';
import 'model.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final NetworkService networkService;

  ItemBloc(this.networkService) : super(ItemInitial()) {
    // Fetch items when the FetchItems event is triggered
    on<FetchItems>((event, emit) async {
      emit(ItemLoading());
      try {
        final items = await networkService.fetchItems();
        emit(ItemLoaded(items));
      } catch (e) {
        emit(ItemError("Failed to load items: $e"));
      }
    });

    // Update item when the UpdateItem event is triggered
    on<UpdateItem>((event, emit) async {
      if (state is ItemLoaded) {
        final currentState = state as ItemLoaded;

        // Optimistic update: Update the UI immediately with the new name
        List<Item> updatedItems = List.from(currentState.items);
        int index = updatedItems.indexWhere((item) => item.id == event.itemId);
        if (index != -1) {
          updatedItems[index].name = event.newName;
        }

        // Emit the optimistic update
        emit(ItemUpdated(updatedItems));

        try {
          // Send the update request to the backend
          final updatedItem = await networkService.updateItem(event.itemId, event.newName);

          // Replace the updated item with the response from the backend
          int updatedIndex = updatedItems.indexWhere((item) => item.id == event.itemId);
          if (updatedIndex != -1) {
            updatedItems[updatedIndex] = updatedItem;  // Update with server response
          }

          // Emit the final list of items with the updated item
          emit(ItemUpdated(updatedItems));
        } catch (e) {
          // Emit error state if the update fails
          emit(ItemError("Failed to update item: $e"));
        }
      }
    });
  }
}


