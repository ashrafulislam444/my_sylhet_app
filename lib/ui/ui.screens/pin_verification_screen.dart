import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_sylhet_version_1/ui/ui.screens/reset_password_screen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../ui.widgets/background_body.dart';
import 'login_screen.dart';



class PinVarification extends StatefulWidget {
  String verificationid;

  PinVarification({super.key,required this.verificationid});

  @override
  State<PinVarification> createState() => _PinVarificationState();
}

class _PinVarificationState extends State<PinVarification> {

  TextEditingController otpController =TextEditingController();


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

                  const SizedBox(height: 90,),

                  Text('PIN Verification',
                    style:Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height:20),

                  Text('A 6 digit verification pin will send to your phone number',
                    style:TextStyle(
                      fontSize: 15,
                      color: Colors.black12,
                      fontWeight: FontWeight.bold,

                    ),
                  ),

                  const SizedBox(height:40,),

                  PinCodeTextField(
                    controller: otpController,
                    keyboardType: TextInputType.phone,
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight:50,
                      fieldWidth: 45,
                      activeFillColor: Colors.white,
                      activeColor: Colors.green,
                      selectedFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                    ),
                    animationDuration:const Duration(milliseconds: 300),
                    backgroundColor: Colors.blue.shade50,
                    enableActiveFill: true,
                    onCompleted: (v) {
                      print("Completed");
                    },
                    onChanged: (value) {

                    },
                    beforeTextPaste: (text) {
                      return true;
                    },
                    appContext: context,
                  ),


                  const SizedBox(height: 30,),
                  SizedBox(
                    width: double.infinity,
                    child:ElevatedButton(
                      onPressed: () async {
                        try{
                          PhoneAuthCredential credential = await PhoneAuthProvider.credential(
                              verificationId: widget.verificationid,
                              smsCode:otpController.text.toString());
                          FirebaseAuth.instance.signInWithCredential(credential).then((value) {
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>ResetPassword()));
                          });

                        } catch (ex){
                          log(ex.toString());
                        }

                      },
                      child:const Text('Verify OTP'),
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