import 'package:cloud_firestore/cloud_firestore.dart';

class HouseOwnerModel {
  String id;
  String address;
  String phone;

  HouseOwnerModel({
    required this.id,
    required this.address,
    required this.phone,
  });


  factory HouseOwnerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HouseOwnerModel(
      id: doc.id,
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
    );
  }
}