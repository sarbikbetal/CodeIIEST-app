import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:codeiiest/screens/wrapper.dart';
import 'package:codeiiest/services/auth.dart';
import 'package:codeiiest/models/user.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: Authenticator().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
