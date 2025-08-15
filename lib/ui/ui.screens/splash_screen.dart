import 'package:flutter/material.dart';
import '../ui.widgets/background_body.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goToLogin();
  }

  void goToLogin() {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });

    return Scaffold(
      body: BackgroundBody(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash.png',
              width: 400,
              height: 380,
              fit: BoxFit.cover,
            ),
            const Text(
              '"Easy Rent Easy Life"',
              style: TextStyle(
                height: 2,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
