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

                  // Image upload section
                  _buildImageUploadSection(),
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

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
// Image picker button
        ElevatedButton.icon(
          onPressed: pickImages,
          icon: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade50,  // Soft background for the icon
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.add_photo_alternate,
              color: Colors.deepPurple,
              size: 20,
            ),
          ),
          label: const Text(
            'Select Images',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            backgroundColor: Colors.white,
            foregroundColor: Colors.deepPurple,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: const BorderSide(color: Colors.transparent),
          ),
        ),

        const SizedBox(height: 10),

        // Preview selected images
        if (selectedImages.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: selectedImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Image.file(
                    selectedImages[index],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),

        if (isUploadingImages)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: LinearProgressIndicator(),
          ),
      ],
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

    if (selectedImages.isEmpty) {
      showToast(message: "Please select at least one image");
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final shopRent = int.tryParse(shopRentController.text);

      if (shopRent == null) {
        showToast(message: "Invalid rent amount");
        return;
      }

      // Upload images first
      List<String> imageUrls = await uploadImages();

      if (imageUrls.isEmpty) {
        showToast(message: "Failed to upload images");
        return;
      }

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