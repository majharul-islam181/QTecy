import 'package:flutter/material.dart';
import '../app/flavors.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Flavors.title),
      ),
      body: Center(
        child: Text(
          'Hello ${Flavors.title}',
        ),
      ),
    );
  }
}