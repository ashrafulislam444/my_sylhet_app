
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../global/common/toast.dart';
import '../ui.widgets/background_body.dart';


class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen ({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {

  final TextEditingController _feedbackcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _feedbackcontroller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Feedback',
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
            padding: EdgeInsets.all(8.0),
             child: SingleChildScrollView(
               child: Column(
                 children: [
                   feedbackMessage,
                 ],
               ),
             )



          ),
        ),
      ),
    );
  }
  AlertDialog get feedbackMessage{
    return AlertDialog(
        content: SingleChildScrollView(

          key: _formKey,
          scrollDirection:Axis.vertical,
          child: Column(
            children: [
              Text('How Would You Rate Oue App?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),),

              const SizedBox(height: 20,),

              RatingBar.builder(
                  initialRating: 0,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating:true,
                  itemCount: 3,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4),
                  itemBuilder: (context,_)=>Icon(Icons.star,
                    color: Colors.red,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  }),

              const SizedBox(height: 20,),
              Text('Please Let Us Know How Can We Improve Ourselves',style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),),

              const SizedBox(height: 20,),

              TextFormField(
                controller: _feedbackcontroller,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Enter your feedback here',
                  filled: true,
                ),
                maxLines: 10,
                maxLength: 4096,
                textInputAction: TextInputAction.done,
                validator: (String? text){
                  if(text == null || text.isEmpty){
                    return 'please enter a value';
                  }
                  return null;
                },
              ),

            ],
          ),
        ),
      
      actions: [

        TextButton(
          child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),

        TextButton(
          child: const Text('Send'),
          onPressed:() {
            final message = _feedbackcontroller.text;
            createUser(message: message);

          }
        ),
       ],

      
    );
  }

  Future createUser({required String message}) async{

    try {
      final docUser = FirebaseFirestore.instance.collection('feedback').doc();
      showToast(message: " Feedback Successfully Send");


      final user = User(
        message:message,
      );

      final json = user.toJson();

      //Create document and write data to Firebase
      await docUser.set(json);

    } catch (e) {
      showToast(message: 'some error occurred ');

    }

    //Reference to document
    //final docUser = FirebaseFirestore.instance.collection('feedback').doc();



    
  }
}

//create a model object

class User{
  final String message;

  User({
    required this.message,
});

  Map<String, dynamic> toJson() =>{
    'message':message,
  };

}
