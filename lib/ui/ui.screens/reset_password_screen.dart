import 'package:flutter/material.dart';
import '../ui.widgets/background_body.dart';
import 'login_screen.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
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

                  Text('Set Password',
                    style:Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height:20),

                  Text('Minimum lenght password 8 character with Letter and number combination',
                    style:TextStyle(
                      fontSize: 15,
                      color: Colors.black12,
                      fontWeight: FontWeight.bold,

                    ),
                  ),

                  const SizedBox(height:50,),

                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                  ),

                  const SizedBox(height: 50,),

                  SizedBox(
                    width: double.infinity,
                    child:ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(context) => const LoginScreen()), (route) => false);
                      },
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                        fontSize: 20,
                        fontWeight:FontWeight.bold,
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
                          Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(context) => const LoginScreen()), (route) => false);
                        },
                        child:  Text('Sign In',style: TextStyle(
                          color: Colors.green,
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