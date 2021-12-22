import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final List<dynamic> imageUrl;
  final double price;
  final sellerName ;
  String category;
  double rating;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
        @required this.sellerName,

        this.category,
      this.isFavorite = false,
      this.rating});


  Future<void> toggleFavorite(String token,String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        "https://flutter-shop-app-ccaf1-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token");
    try {
      final response = await http.put(
        url,
        body: json.encode(isFavorite),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
  void _setFavValue(newValue){
    isFavorite = newValue;
    notifyListeners();
  }
}

