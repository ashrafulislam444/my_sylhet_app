import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_sylhet_version_1/ui/ui.screens/settings_screen.dart';
import '../ui.widgets/background_body.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _PasswordController = TextEditingController();

  late User currentUser;
  String? userID;

  @override
  void initState() {
    super.initState();
    getUserID();
  }

  Future<void> getUserID() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUser = user;
      });
      showUserData();
    }
  }

  Future<void> showUserData() async {
    String userID = currentUser.uid;
    var userDoc = await FirebaseFirestore.instance.collection('userid').doc(userID).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _firstNameController.text = userData['firstName'] ?? '';
        _lastNameController.text = userData['lastName'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _phoneController.text = userData['phone'] ?? '';
        _PasswordController.text = userData['password'] ?? '';
      });
    }
  }

  Future<void> updateUserDetails() async {
    String userID = currentUser.uid;

    var userDoc = await FirebaseFirestore.instance.collection('userid').doc(userID).get();

    if (userDoc.exists) {
      await FirebaseFirestore.instance.collection('userid').doc(userID).update({
        'email': _emailController.text,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'phone': _phoneController.text,
        'password': _PasswordController.text,
      });
    } else {
      await FirebaseFirestore.instance.collection('userid').doc(userID).set({
        'email': _emailController.text,
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'phone': _phoneController.text,
        'password': _PasswordController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        toolbarHeight: 60,
        elevation: 15,
        backgroundColor: Colors.black,
      ),
      body: BackgroundBody(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(hintText: 'Email'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(hintText: 'First Name'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(hintText: 'Last Name'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(hintText: 'Phone'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _PasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: 'Password'),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        updateUserDetails();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingsScreen()),
                        );
                      },
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10.0),
                        fixedSize: const Size(200, 50),
                        elevation: 5,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.transparent, width: 3),
                        shape: const StadiumBorder(),
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
}
