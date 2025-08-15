import 'package:cloud_firestore/cloud_firestore.dart';

class TransportOwnerModel {
  String id;
  String address;
  String phone;

  TransportOwnerModel({
    required this.id,
    required this.address,
    required this.phone,
  });

  factory TransportOwnerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransportOwnerModel(
      id: doc.id,
      address: data['address'] ?? '',
      phone: data['phone'] ?? '',
    );
  }
}