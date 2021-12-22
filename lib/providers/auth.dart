import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/model/user_model.dart';
import 'package:shop_app/module/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  String _refreshToken;

  String get refreshToken {
    return _refreshToken;
  }

  bool get isAuth {
    return token != null;
  }

  DateTime get expiryDate {
    return _expiryDate;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      // refreshTokenMethod();
      return _token;
    } else {
      return null;
    }
  }

  String get userId {
    return _userId;
  }

  // Future<void> _authenticate(
  //     String email, String password, String urlSegment) async {
  //   final url = Uri.parse(
  //       "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAPPCezMKtrPzB8ziJUtEGDe4jCucyel1M");
  //   try {
  //     final response = await http.post(url,
  //         body: json.encode({
  //           "email": email,
  //           "password": password,
  //           "returnSecureToken": true
  //         }));
  //
  //     final responseData = json.decode(response.body);
  //     print(responseData);
  //     if (responseData["error"] != null) {
  //       throw HttpException(responseData["error"]["message"]);
  //     }
  //     _token = responseData["idToken"];
  //     _refreshToken = responseData['refreshToken'];
  //
  //     _userId = responseData["localId"];
  //     _expiryDate = DateTime.now()
  //         .add(Duration(seconds: int.parse(responseData["expiresIn"])));
  //     print(_expiryDate);
  //     notifyListeners();
  //     final prefs = await SharedPreferences.getInstance();
  //     final userData = json.encode({
  //       'token': _token,
  //       'refreshToken': _refreshToken.toString(),
  //       'userId': _userId,
  //       'expiryDate': _expiryDate.toIso8601String()
  //     });
  //     print(userData);
  //
  //     prefs.setString("userData", userData);
  //   } catch (error) {
  //     throw error;
  //   }
  // }



  // Future<void> signup(String email, String password) async {
  //   return _authenticate(email, password, "signUp");
  // }

  registerWithEmailAndPassword(
      String email, String password, String userName) async {
    try {
      AuthResult userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) =>
      signInWithEmailAndPassword(email, password);
    } on AuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on AuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    notifyListeners();
  }
  // Future<void> login(String email, String password) async {
  //   return _authenticate(email, password, "signInWithPassword");
  // }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    print(expiryDate);
    if (expiryDate.isBefore(DateTime.now())) {
      // refreshTokenMethod();
      return false;
    }
    _token = extractedUserData['token'];
    _refreshToken = extractedUserData['refreshToken'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;

    notifyListeners();

    return true;
  }

  // Future<void> refreshTokenMethod() async {
  //   final url = Uri.parse(
  //       "https://securetoken.googleapis.com/v1/token?key=AIzaSyAPPCezMKtrPzB8ziJUtEGDe4jCucyel1M");
  //   if (_refreshToken != null) {
  //     final response = await http.post(url,
  //         headers: {
  //           "Accept": "application/json",
  //           "Content-Type": "application/x-www-form-urlencoded"
  //         },
  //         body: json.encode({
  //           "grant_type": 'refresh_token',
  //           "refresh_token": _refreshToken,
  //         }));
  //     if (response.statusCode == 200) {
  //       final responseToken = json.decode(response.body);
  //       _refreshToken = responseToken['refresh_token'];
  //       _userId = responseToken['user_id'];
  //       _expiryDate = DateTime.parse(responseToken['expires_in']);
  //       _token = responseToken['id_token'];
  //       final prefs = await SharedPreferences.getInstance();
  //       prefs.setString("userData", responseToken);
  //       notifyListeners();
  //     }
  //   }
  // }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  Future<void> addUser(UserModel user , authToken) async {
    final url = Uri.parse(
        "https://flutter-shop-app-ccaf1-default-rtdb.firebaseio.com/User.json?auth=$authToken");

    try {
      final response = await http.post(url,
          body: json.encode({
            "title": product.title,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "creatorId" : userId,
          }));

      var newProduct = Product(
          id: json.decode(response.body)["name"],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }
}
