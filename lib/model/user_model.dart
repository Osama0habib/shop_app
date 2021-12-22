import 'package:shop_app/model/review_model.dart';

class UserModel {
 final String userName ;
 final String email ;
 final String phoneNumber;
 final String store;
 final String address;
 final int rating;
 final List<ReviewModel> reviews;

  UserModel({this.userName, this.email, this.phoneNumber, this.store, this.address, this.rating, this.reviews});

}