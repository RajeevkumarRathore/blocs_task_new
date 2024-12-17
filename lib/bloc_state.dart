import 'model.dart';
abstract class ItemState {}
class ItemInitial extends ItemState {}
class ItemLoading extends ItemState {}
class ItemLoaded extends ItemState {
  final List<Item> items;
  ItemLoaded(this.items);
}
class ItemUpdated extends ItemState {
  final List<Item> items;
  ItemUpdated(this.items);
}
class ItemError extends ItemState {
  final String message;
  ItemError(this.message);
}
