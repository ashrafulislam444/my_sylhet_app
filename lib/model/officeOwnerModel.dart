import 'package:cloud_firestore/cloud_firestore.dart';

class OfficeOwnerModel {
  String id;
  String address;
  String phone;

  OfficeOwnerModel({
    required this.id,
    required this.address,
    required this.phone,
  });

  factory OfficeOwnerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OfficeOwnerModel(
      id: doc.id,
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
    );
  }
}