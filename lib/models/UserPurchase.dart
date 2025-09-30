import 'constants/Constants.dart';

class UserPurchase {

  String mongoId = Constants.defMongoId;

  String productId = Constants.empty;

  UserPurchase({required this.mongoId, required this.productId});

  UserPurchase.def();

  static UserPurchase fromJson(dynamic json){
    return UserPurchase(mongoId: json['mongoId'], productId: json['productId']);
  }

  void copyFrom(UserPurchase other){
    mongoId = other.mongoId;
    productId = other.productId;
  }

}