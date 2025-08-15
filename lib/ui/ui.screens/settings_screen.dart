import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_sylhet_version_1/ui/ui.screens/update_profile_screen.dart';
import '../global/common/toast.dart';
import '../ui.widgets/background_body.dart';
import 'contact_screen.dart';
import 'feedback_screen.dart';
import 'login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image.asset(
          'assets/images/Settings.png',
          fit: BoxFit.fill,
        ),
        toolbarHeight: 100,
        elevation: 15,
        backgroundColor: Colors.grey,
      ),
      body: BackgroundBody(
        child: Column(
          children: [
            const SizedBox(height: 120, width: 400),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateProfileScreen()),
                  );
                },
                child: const Text(
                  'Update Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10.0),
                  fixedSize: const Size(250, 50),
                  elevation: 5,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.transparent, width: 3),
                  shape: const StadiumBorder(),
                ),
              ),
            ),
            const SizedBox(height: 40, width: 400),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FeedbackScreen()),
                  );
                },
                child: const Text(
                  'Feedback',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10.0),
                  fixedSize: const Size(250, 50),
                  elevation: 5,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.transparent, width: 3),
                  shape: const StadiumBorder(),
                ),
              ),
            ),
            const SizedBox(height: 40, width: 400),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ContactScreen()),
                  );
                },
                child: const Text(
                  'Contact',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10.0),
                  fixedSize: const Size(250, 50),
                  elevation: 5,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.transparent, width: 3),
                  shape: const StadiumBorder(),
                ),
              ),
            ),
            const SizedBox(height: 40, width: 400),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                  showToast(message: "Successfully signed out");
                },
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(10.0),
                  fixedSize: const Size(250, 50),
                  elevation: 5,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.transparent, width: 3),
                  shape: const StadiumBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
