import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../global/common/toast.dart';
import '../../ui.widgets/background_body.dart';

class ShopAddDetails extends StatefulWidget {
  final String ownerId;

  const ShopAddDetails({super.key, required this.ownerId});

  @override
  State<ShopAddDetails> createState() => _ShopAddDetailsState();
}

class _ShopAddDetailsState extends State<ShopAddDetails> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController shopRentController = TextEditingController();
  final TextEditingController shopNoController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController complexController = TextEditingController();
  bool isSubmitting = false;

  List<File> selectedImages = [];
  bool isUploadingImages = false;

  @override
  void dispose() {
    descriptionController.dispose();
    shopRentController.dispose();
    shopNoController.dispose();
    floorController.dispose();
    complexController.dispose();
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
        String fileName = 'shop_${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
        Reference storageRef = FirebaseStorage.instance.ref().child('shop_images/$fileName');
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
                      'Provide Shop Information',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(height: 30),

                  const SizedBox(height: 20),

                  _buildInputField('Description', descriptionController, maxLines: 2),
                  const SizedBox(height: 20),
                  _buildInputField('Shop Rent', shopRentController, keyboardType: TextInputType.number),
                  const SizedBox(height: 20),
                  _buildInputField('Shop No.', shopNoController),
                  const SizedBox(height: 20),
                  _buildInputField('Floor', floorController),
                  const SizedBox(height: 20),
                  _buildInputField('Complex/Market Name', complexController),

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
        shopRentController.text.isEmpty ||
        shopNoController.text.isEmpty ||
        floorController.text.isEmpty ||
        complexController.text.isEmpty) {
      showToast(message: "Please fill all fields");
      return;
    }


    setState(() => isSubmitting = true);

    try {
      final shopRent = int.tryParse(shopRentController.text);

      if (shopRent == null) {
        showToast(message: "Invalid rent amount");
        return;
      }


      List<String> imageUrls = await uploadImages();


      final details = {
        'ownerId': widget.ownerId,
        'description': descriptionController.text,
        'shopRent': shopRent,
        'shopNo': shopNoController.text,
        'floor': floorController.text,
        'complex': complexController.text,
        'imageUrls': imageUrls, // Store image URLs
        'createdAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance.collection('Shop Details').add(details);
      showToast(message: "Details Submitted Successfully");
      Navigator.pop(context);
    } catch (e) {
      showToast(message: "Error: $e");
    } finally {
      setState(() => isSubmitting = false);
    }
  }
}