import 'package:flutter/material.dart';
import 'package:codeiiest/screens/home.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.cyan[700],
        accentColor: Colors.green[300],
      ),
      home: Home(),
    );
  }
}
