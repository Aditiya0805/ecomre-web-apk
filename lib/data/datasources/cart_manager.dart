import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../models/snack_model.dart';

class CartManager extends ChangeNotifier {
  // Singleton pattern agar state keranjang dapat diakses dari seluruh screen
  CartManager._internal();
  static final CartManager instance = CartManager._internal();

  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => List.unmodifiable(_items);

  int get totalItems => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  bool get isEmpty => _items.isEmpty;

  int getItemQuantity(String snackId) {
    final index = _items.indexWhere((item) => item.snack.id == snackId);
    if (index != -1) {
      return _items[index].quantity;
    }
    return 0;
  }

  void addItem(SnackModel snack, [int quantity = 1]) {
    if (quantity <= 0) return;
    final index = _items.indexWhere((item) => item.snack.id == snack.id);
    if (index != -1) {
      // Tambah quantity jika item sudah ada di keranjang
      final currentQty = _items[index].quantity;
      final maxAvailable = snack.stock;
      final newQty = (currentQty + quantity).clamp(1, maxAvailable);
      _items[index].quantity = newQty;
    } else {
      // Tambah item baru
      final validQty = quantity.clamp(1, snack.stock);
      _items.add(CartItemModel(snack: snack, quantity: validQty));
    }
    notifyListeners();
  }

  void updateQuantity(String snackId, int delta) {
    final index = _items.indexWhere((item) => item.snack.id == snackId);
    if (index != -1) {
      final currentItem = _items[index];
      final newQty = currentItem.quantity + delta;

      if (newQty <= 0) {
        _items.removeAt(index);
      } else if (newQty <= currentItem.snack.stock) {
        currentItem.quantity = newQty;
      }
      notifyListeners();
    }
  }

  void removeItem(String snackId) {
    _items.removeWhere((item) => item.snack.id == snackId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
