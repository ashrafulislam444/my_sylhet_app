import 'package:flutter/material.dart';

class BackgroundBody extends StatelessWidget {
  const BackgroundBody({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF8E7F8),
                Color(0xFFF8D3D6),
                Color(0xFFE2F0FB),
              ],
              stops: [0.1, 0.5, 0.9],
            ),
          ),
        ),
        child,
      ],
    );
  }
}