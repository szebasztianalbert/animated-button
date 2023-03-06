import 'package:flutter/material.dart';

import 'animated_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Animated button'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          AnimatedButton(
            width: 170,
            height: 80,
            loadingAnimationDuration: Duration(seconds: 1),
            enabledButtonBackgroundColor: Colors.black,
            disabledButtonBackgroundColor: Colors.blue,
            loadingAnimationColor: Colors.lightGreen,
            textColor: Colors.red,
            buttonText: 'Customized',
          ),
          SizedBox(
            height: 50,
          ),
          AnimatedButton(
            buttonText: 'Default',
          ),
          SizedBox(
            height: 50,
          ),
          AnimatedButton(
            enabled: false,
            buttonText: 'Disabled',
          ),
        ],
      ),
    ));
  }
}
