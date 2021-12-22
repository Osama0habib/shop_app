import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/module/http_exception.dart';
import 'package:shop_app/model/product.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  StorageReference storageReference = FirebaseStorage.instance.ref();
  String downloadUrl1;
  List<Product> _items = [];
  String authToken;
 String userId;



  void update(authToken,userId ,item){
    this.authToken = authToken;
    this.userId = userId;
    this._items = item;
  }



  List<Product> get item {
    return [..._items];
  }

  List<Product> get favorite {
    return _items.where((product) => product.isFavorite).toList();
  }

  List<Product> getSearch(String searchQuery){
    return _items.where((product) => product.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  Product findById(id) {
    return _items.firstWhere((product) => product.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser =false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse(
        'https://flutter-shop-app-ccaf1-default-rtdb.firebaseio.com/product.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedData = [];
      if(extractedData == null){
        return;
      }
      url = Uri.parse(
          'https://flutter-shop-app-ccaf1-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favoriteStatusResponse = await http.get(url);
      final favoriteData = json.decode(favoriteStatusResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedData.add(Product(
            id: prodId,
            title: prodData["title"],
            imageUrl: prodData["imageUrl"],
            price: prodData["price"],
            description: prodData["description"],
            sellerName: prodData["creatorId"],
            isFavorite: favoriteData ==  null ? false :  favoriteData[prodId] ?? false));
      });
      _items = loadedData;
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        "https://flutter-shop-app-ccaf1-default-rtdb.firebaseio.com/product.json?auth=$authToken");

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


  Future<List<String>> uploadFiles(List<PickedFile> _images) async {
    var imageUrls = await Future.wait(_images.map((_image) => uploadFile(File(_image.path))));
    print(imageUrls);
    return imageUrls;
  }

  Future<String> uploadFile(File _image) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('Product/${_image.path.split("/").last}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;

    return await storageReference.getDownloadURL();
  }
//   Future<void> addImageToFirebase(image) async {
// List<PickedFile> _image = image;
// List<File> fileImage =[];
// _image.forEach((img) {
//  File fImage = File(img.path);
//  fileImage.add(fImage);
// });
//
// //CreateRefernce to path.
//     StorageReference ref = storageReference.child("product/$userId/");
//
//     //StorageUpload task is used to put the data you want in storage
//     //Make sure to get the image first before calling this method otherwise _image will be null.
//
//     StorageUploadTask storageUploadTask = ref.child(fileImage[0].path.split("/").last).putFile(fileImage[0]);
//
//     if (storageUploadTask.isSuccessful || storageUploadTask.isComplete) {
//       final String url = await ref.getDownloadURL();
//       print("The download URL is " + url);
//     } else if (storageUploadTask.isInProgress) {
//
//       storageUploadTask.events.listen((event) {
//         double percentage = 100 *(event.snapshot.bytesTransferred.toDouble()
//             / event.snapshot.totalByteCount.toDouble());
//         print("THe percentage " + percentage.toString());
//       });
//
//       StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;
//       downloadUrl1 = await storageTaskSnapshot.ref.getDownloadURL();
//
//       //Here you can get the download URL when the task has been completed.
//       print("Download URL " + downloadUrl1.toString());
//
//     } else{
//       //Catch any cases here that might come up like canceled, interrupted
//     }
//
//   }

  Future<void> updateProduct(id, newProduct)async {
    var currentProdcut = _items.indexWhere((element) => element.id == id);
    final url = Uri.parse(
        "https://flutter-shop-app-ccaf1-default-rtdb.firebaseio.com/product/$id.json?auth=$authToken");
    if (currentProdcut >= 0) {
     await http.patch(url , body: json.encode({
        "title": newProduct.title,
        "description": newProduct.description,
        "imageUrl": newProduct.imageUrl,
        "price": newProduct.price,
      }));
      _items[currentProdcut] = newProduct;
      notifyListeners();
    } else {
      print("....");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://flutter-shop-app-ccaf1-default-rtdb.firebaseio.com/product/$id.json?auth=$authToken");
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
