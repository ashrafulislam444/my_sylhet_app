import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_sylhet_version_1/ui/ui.screens/sign_up_screen.dart';
import '../feature/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import '../global/common/toast.dart';
import '../ui.widgets/background_body.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundBody(
        child:SafeArea(
          child:Padding(
            padding: const EdgeInsets.all(24.0),
            child:SingleChildScrollView(
              child:Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 80,),
                    Text('Get Started With',
                      style:Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height:50,),

                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter an email';
                        }

                        bool emailValid = RegExp(
                            r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                            .hasMatch(value!);
                        if (emailValid == false) {
                          return 'Enter valid Email';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 30,),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Passwords',
                      ),
                      validator: (String? value) {
                        if (value?.isEmpty ?? true) {
                          return 'Enter a Password';
                        }
                        if (value!.length < 6) {
                          return 'Enter Password more than 6 letters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 50,),
                    SizedBox(
                      width: double.infinity,
                      child:ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            loginUser();
                            return;
                          }

                        },
                        child:_isSigning ? CircularProgressIndicator(color: Colors.black,): Text(
                          'Sign In',
                          style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                            color: Colors.black,
                        ),),
                      ),
                    ),

                    const SizedBox(height: 50),

                    Center(child: TextButton(
                      onPressed: (){
                        Navigator.push(context,
                          MaterialPageRoute(builder:(context) => const ForgotPassword(),
                          ),
                        );
                      },child:  Text('Forgot Password?',style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,

                    ),
                    ),
                    ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?",style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ), ),
                        TextButton(
                          onPressed: (){
                            Navigator.push(context,
                              MaterialPageRoute(builder:(context) => const SignUpScreen(),
                              ),
                            );
                          },
                          child:  Text('Sign Up',style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,

                          ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),

            ),

          ),
        ),
      ),

    );
  }

  Future loginUser() async {

    setState(() {
      _isSigning = true;
    });



    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      showToast(message: "successfully Logging");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));

    } catch (e) {
      showToast(message: 'some error occurred ');

    }

    setState(() {
      _isSigning = false;
    });

  }

}