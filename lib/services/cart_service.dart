import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final String unit;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.unit,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'unit': unit,
      'price': price,
      'quantity': quantity,
      'imageUrl': imageUrl,
    };
  }
}

class CartService {
  CartService._internal();
  static final CartService instance = CartService._internal();

  final ValueNotifier<int> cartCountNotifier = ValueNotifier<int>(0);
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItemCount =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  void _notifyChange() {
    cartCountNotifier.value = totalItemCount;
  }

  void addItem({
    required String id,
    required String name,
    required String unit,
    required double price,
    required String imageUrl,
    int quantity = 1,
  }) {
    final index = _items.indexWhere(
        (item) => item.id == id && item.unit == unit);

    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(
        id: id,
        name: name,
        unit: unit,
        price: price,
        imageUrl: imageUrl,
        quantity: quantity,
      ));
    }
    _notifyChange();
  }

  void updateQuantity(int index, int delta) {
    if (index >= 0 && index < _items.length) {
      _items[index].quantity += delta;
      if (_items[index].quantity <= 0) {
        _items.removeAt(index);
      }
      _notifyChange();
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      _notifyChange();
    }
  }

  void clearCart() {
    _items.clear();
    _notifyChange();
  }

  int getQuantityForProduct(String productId) {
    return _items
        .where((item) => item.id == productId)
        .fold(0, (sum, item) => sum + item.quantity);
  }
}
