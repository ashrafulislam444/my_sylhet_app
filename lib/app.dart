import 'package:flutter/material.dart';
import 'package:my_sylhet_version_1/ui/ui.screens/splash_screen.dart';



class MySylhet extends StatelessWidget{
  const MySylhet({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      home: const SplashScreen(child: null,),
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.black12,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(35),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(35),
            ),
        ),

        textTheme:const TextTheme(
          titleLarge:TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.w600,
        ),
        ),
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),

          )
        )
      ),

    );
  }

}