

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../global/common/toast.dart';
import '../../ui.widgets/background_body.dart';

class OfficeAddDetails extends StatefulWidget {
  final String ownerId;

  const OfficeAddDetails({super.key, required this.ownerId});

  @override
  State<OfficeAddDetails> createState() => _OfficeAddDetailsState();
}

class _OfficeAddDetailsState extends State<OfficeAddDetails> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController monthlyRentController = TextEditingController();
  final TextEditingController officeNoController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController buildingNameController = TextEditingController();
  bool isSubmitting = false;

  @override
  void dispose() {
    descriptionController.dispose();
    monthlyRentController.dispose();
    officeNoController.dispose();
    floorController.dispose();
    buildingNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image.asset(
          'assets/images/Add Details.png',
          fit: BoxFit.cover,
        ),
        toolbarHeight: 100,
        elevation: 15,
        backgroundColor: Colors.grey,
      ),
      body: BackgroundBody(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Provide Office Information',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const SizedBox(height: 10),

                  _buildInputField('Description', descriptionController, maxLines: 3),
                  const SizedBox(height: 20),
                  _buildInputField('Monthly Rent', monthlyRentController, keyboardType: TextInputType.number),
                  const SizedBox(height: 20),
                  _buildInputField('Office No.', officeNoController),
                  const SizedBox(height: 20),
                  _buildInputField('Floor', floorController),
                  const SizedBox(height: 20),
                  _buildInputField('Building Name', buildingNameController),

                  const SizedBox(height: 40),
                  Center(
                    child: isSubmitting
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: submitDetails,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        fixedSize: const Size(200, 60),
                        elevation: 10,
                        backgroundColor: Colors.blueGrey,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Submit Details',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String hint, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.all(15),
        ),
      ),
    );
  }

  Future<void> submitDetails() async {
    if (descriptionController.text.isEmpty ||
        monthlyRentController.text.isEmpty ||
        officeNoController.text.isEmpty ||
        floorController.text.isEmpty ||
        buildingNameController.text.isEmpty) {
      showToast(message: "Please fill all fields");
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final monthlyRent = int.tryParse(monthlyRentController.text);

      if (monthlyRent == null) {
        showToast(message: "Invalid rent amount");
        return;
      }

      final details = {
        'ownerId': widget.ownerId,
        'description': descriptionController.text,
        'monthlyRent': monthlyRent,
        'officeNo': officeNoController.text,
        'floor': floorController.text,
        'buildingName': buildingNameController.text,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('Office Details').add(details);
      showToast(message: "Details Submitted Successfully");
      Navigator.pop(context);
    } catch (e) {
      showToast(message: "Error: $e");
    } finally {
      setState(() => isSubmitting = false);
    }
  }
}