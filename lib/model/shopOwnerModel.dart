import 'package:cloud_firestore/cloud_firestore.dart';

class ShopOwnerModel {
  String id;
  String address;
  String phone;

  ShopOwnerModel({
    required this.id,
    required this.address,
    required this.phone,
  });

  factory ShopOwnerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShopOwnerModel(
      id: doc.id,
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
    );
  }
}