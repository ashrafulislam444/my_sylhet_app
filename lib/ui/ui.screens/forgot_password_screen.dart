import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:rent_ez/ui/ui.screens/pin_verification_screen.dart';


import '../ui.widgets/background_body.dart';
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController = TextEditingController();

  Future passwordReset() async {
    try {
      print(_emailController);
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                'Password Reset Link Sent to Your Email',
              ),
            );
          });

    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                e.message.toString(),
              ),
            );
          });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundBody(
        child:SafeArea(
          child:Padding(
            padding: const EdgeInsets.all(24.0),
            child:SingleChildScrollView(
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 80,),

                  Text('Your Email Address',
                    style:Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height:20),

                  Text('A 6 digit verification pin will send to your email address',
                    style:TextStyle(
                      fontSize: 15,
                      color: Colors.black12,
                      fontWeight: FontWeight.bold,

                    ),
                  ),

                  const SizedBox(height:50,),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                  ),

                  const SizedBox(height: 50,),
                  SizedBox(
                    width: double.infinity,
                    child:ElevatedButton(
                      onPressed: () {
                        passwordReset();
                        // Navigator.push(context,
                        //   MaterialPageRoute(builder:(context) => const PinVarification(),
                        //   ),
                        // );
                      },
                      child:const Text('Continue',style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),),
                    ),
                  ),

                  const SizedBox(height: 50),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?",style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ), ),
                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child:  Text('Sign In',style: TextStyle(
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

    );
  }
}