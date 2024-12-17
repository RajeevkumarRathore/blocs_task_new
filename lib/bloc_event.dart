// bloc_event.dart
abstract class ItemEvent {}
class FetchItems extends ItemEvent {}
class UpdateItem extends ItemEvent {
  final int itemId;
  final String newName;
  UpdateItem(this.itemId, this.newName);
}
