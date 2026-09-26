import 'snack_model.dart';

class CartItemModel {
  final SnackModel snack;
  int quantity;

  CartItemModel({
    required this.snack,
    this.quantity = 1,
  });

  double get totalPrice => snack.price * quantity;
}
