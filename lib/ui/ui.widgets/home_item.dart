import 'package:flutter/material.dart';

class HouseItem extends StatelessWidget {
  const HouseItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            //child: Icon(Icons.house,size: 32,),
          ),
        ),
        //Text('House'),
      ],
    );
  }
}