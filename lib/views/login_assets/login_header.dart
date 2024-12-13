import 'package:flutter/material.dart';

class LoginHeader  extends StatelessWidget {
  const LoginHeader ({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 100,),
        const Icon(Icons.book_online,color: Colors.red,size: 100,),
        Text("login".toUpperCase(),style:const TextStyle(fontSize: 50),),
        const SizedBox(height: 50,)
      ],
    );
  }
}
