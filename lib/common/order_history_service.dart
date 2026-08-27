import 'package:flutter/foundation.dart';

import 'cart_service.dart';

class Order {
  final List<CartItem> items;
  final double total;
  final DateTime placedAt;

  Order({required this.items, required this.total, required this.placedAt});
}

/// In-memory order history - no backend, resets on app reload.
class OrderHistoryService extends ValueNotifier<List<Order>> {
  OrderHistoryService._() : super([]);
  static final OrderHistoryService instance = OrderHistoryService._();

  void add(Order order) {
    value.insert(0, order);
    notifyListeners();
  }

  void clear() {
    value.clear();
    notifyListeners();
  }
}
