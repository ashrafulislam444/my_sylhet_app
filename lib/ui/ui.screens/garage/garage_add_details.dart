import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../global/common/toast.dart';
import '../../ui.widgets/background_body.dart';

class GarageAddDetails extends StatefulWidget {
  final String ownerId;

  const GarageAddDetails({super.key, required this.ownerId});

  @override
  State<GarageAddDetails> createState() => _GarageAddDetailsState();
}

class _GarageAddDetailsState extends State<GarageAddDetails> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController monthlyRentController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController vehicleCapacityController = TextEditingController();
  final TextEditingController locationDetailsController = TextEditingController();
  String? selectedGarageType;
  bool isSubmitting = false;

  List<File> selectedImages = [];
  bool isUploadingImages = false;

  final List<String> garageTypes = ['Residential', 'Commercial', 'Covered', 'Open'];

  @override
  void dispose() {
    descriptionController.dispose();
    monthlyRentController.dispose();
    sizeController.dispose();
    vehicleCapacityController.dispose();
    locationDetailsController.dispose();
    super.dispose();
  }

  Future<void> pickImages() async {
    try {
      final pickedFiles = await ImagePicker().pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        setState(() {
          selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
        });
      }
    } catch (e) {
      showToast(message: "Image picker error: $e");
    }
  }

  Future<List<String>> uploadImages() async {
    List<String> imageUrls = [];
    setState(() => isUploadingImages = true);

    try {
      for (var image in selectedImages) {
        String fileName = 'garage_${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
        Reference storageRef = FirebaseStorage.instance.ref().child('garage_images/$fileName');
        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }
      return imageUrls;
    } catch (e) {
      showToast(message: "Upload failed: $e");
      return [];
    } finally {
      setState(() => isUploadingImages = false);
    }
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
                      'Provide Garage Information',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Image upload section
                 // _buildImageUploadSection(),
                  const SizedBox(height: 20),

                  _buildInputField('Description', descriptionController, maxLines: 2),
                  const SizedBox(height: 20),
                  _buildInputField('Monthly Rent', monthlyRentController, keyboardType: TextInputType.number),
                  const SizedBox(height: 20),
                  _buildInputField('Size (e.g., 20x20 ft)', sizeController),
                  const SizedBox(height: 20),
                  _buildInputField('Vehicle Capacity', vehicleCapacityController, keyboardType: TextInputType.number),
                  const SizedBox(height: 20),
                  _buildInputField('Location Details', locationDetailsController),
                  const SizedBox(height: 20),

                  // Garage Type Dropdown
                  const Text(
                    'Garage Type:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedGarageType,
                    items: garageTypes.map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    )).toList(),
                    onChanged: (value) => setState(() => selectedGarageType = value),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    ),
                  ),

                  const SizedBox(height: 40),
                  Center(
                    child: (isSubmitting || isUploadingImages)
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
        sizeController.text.isEmpty ||
        vehicleCapacityController.text.isEmpty ||
        locationDetailsController.text.isEmpty ||
        selectedGarageType == null) {
      showToast(message: "Please fill all fields");
      return;
    }


    setState(() => isSubmitting = true);

    try {
      final monthlyRent = int.tryParse(monthlyRentController.text);
      final vehicleCapacity = int.tryParse(vehicleCapacityController.text);

      if (monthlyRent == null || vehicleCapacity == null) {
        showToast(message: "Invalid number format");
        return;
      }

      // Upload images first
      List<String> imageUrls = await uploadImages();


      final details = {
        'ownerId': widget.ownerId,
        'description': descriptionController.text,
        'monthlyRent': monthlyRent,
        'size': sizeController.text,
        'vehicleCapacity': vehicleCapacity,
        'locationDetails': locationDetailsController.text,
        'garageType': selectedGarageType,
        'imageUrls': imageUrls, // Store image URLs
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('Garage Details').add(details);
      showToast(message: "Details Submitted Successfully");
      Navigator.pop(context);
    } catch (e) {
      showToast(message: "Error: $e");
    } finally {
      setState(() => isSubmitting = false);
    }
  }
}