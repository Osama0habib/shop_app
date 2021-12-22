import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final List<CartItem> product;

  final double amount;

  final String id;
  final DateTime dateTime;

  OrderItem(
      {@required this.product,
      @required this.amount,
      @required this.id,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  Orders(this.authToken,this._orders, this.userId);

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String authToken;
  final String userId;


  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        "https://flutter-shop-app-ccaf1-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken");
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    print(extractedData);
    if(extractedData == null){
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          product: (orderData["product"] as List<dynamic>)
              .map((item) => CartItem(
                  id: item["id"],
                  title: item["title"],
                  price: item["price"],
                  quantity: item["quantity"]))
              .toList(),
          amount: orderData["amount"],
          id: orderId,
          dateTime: DateTime.parse(orderData["datetime"])));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        "https://flutter-shop-app-ccaf1-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken");
    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          "amount": total,
          "datetime": timeStamp.toIso8601String(),
          "product":
            cartProducts
                .map((cp) => {
                      "id": cp.id,
                      "quantity": cp.quantity,
                      "title": cp.title,
                      "price": cp.price
                    })
                .toList()

        }));
    _orders.insert(
        0,
        OrderItem(
            product: cartProducts,
            amount: total,
            id: json.decode(response.body)["name"],
            dateTime: timeStamp));
    notifyListeners();
  }
}
