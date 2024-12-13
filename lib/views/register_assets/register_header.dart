import 'package:flutter/material.dart';

class RegisterHeader  extends StatelessWidget {
  const RegisterHeader ({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 100,),
        const  Icon(Icons.book_online,color: Colors.red,size: 100,),
        Text("register".toUpperCase(),style: const TextStyle(fontSize: 50),),
        const  SizedBox(height: 50,)
      ],
    );
  }
}
