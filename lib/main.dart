import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flowwie',
      home: Scaffold(
        appBar: AppBar(title: Text('Flowwie')),
        body: Center(
          child: Container(
            child: Text('Welcome to Flowwie!'),
          ),
        ),
      ),
    );
  }
}
