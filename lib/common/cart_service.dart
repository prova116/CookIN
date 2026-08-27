import 'package:flutter/foundation.dart';

class CartItem {
  final String name;
  final String image;
  final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });

  double get total => price * quantity;
}

/// Simple in-memory cart, shared across the app. There's no backend, so this
/// only lives for the current app session and resets on reload.
class CartService extends ValueNotifier<List<CartItem>> {
  CartService._() : super([]);
  static final CartService instance = CartService._();

  void add(String name, String image, double price, {int quantity = 1}) {
    final index = value.indexWhere((item) => item.name == name);
    if (index >= 0) {
      value[index].quantity += quantity;
    } else {
      value.add(CartItem(
          name: name, image: image, price: price, quantity: quantity));
    }
    notifyListeners();
  }

  void updateQuantity(CartItem item, int quantity) {
    if (quantity <= 0) {
      remove(item);
      return;
    }
    item.quantity = quantity;
    notifyListeners();
  }

  void remove(CartItem item) {
    value.remove(item);
    notifyListeners();
  }

  void clear() {
    value.clear();
    notifyListeners();
  }

  double get total => value.fold(0.0, (sum, item) => sum + item.total);

  int get itemCount => value.fold(0, (sum, item) => sum + item.quantity);
}
