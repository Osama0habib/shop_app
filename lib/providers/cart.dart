import 'package:flutter/foundation.dart';

class CartItem {
  final String id;

  final String title;

  final double price;

  final int quantity;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _item = {};

  Map<String, CartItem> get item {
    return {..._item};
  }

  int get itemCount {
    return _item.length;
  }

  double get totalPrice {
    var total = 0.0;
    _item.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double productPrice, String title) {

    if (_item.containsKey(productId)) {
      _item.update(
          productId,
          (exsitingCartItem) => CartItem(
              id: exsitingCartItem.id,
              title: exsitingCartItem.title,
              price: exsitingCartItem.price,
              quantity: exsitingCartItem.quantity + 1));
    } else {
      _item.putIfAbsent(
          productId,
          () => CartItem(
              id: productId, title: title, price: productPrice, quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(productId) {
    _item.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _item.clear();
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_item.containsKey(productId)) {
      return;
    }
    if (_item[productId].quantity > 1) {
      _item.update(productId, (exsistingCartItem) {
        return CartItem(
            id: exsistingCartItem.id,
            title: exsistingCartItem.title,
            price: exsistingCartItem.price,
            quantity: exsistingCartItem.quantity - 1);
      });
    } else {
      removeItem(productId);
    }
  }
}
