import 'package:cloud_firestore/cloud_firestore.dart';

class GarageOwnerModel {
  String id;
  String address;
  String phone;

  GarageOwnerModel({
    required this.id,
    required this.address,
    required this.phone,
  });

  factory GarageOwnerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GarageOwnerModel(
      id: doc.id,
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
    );
  }
}