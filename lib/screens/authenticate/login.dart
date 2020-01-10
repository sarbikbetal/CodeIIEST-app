import 'package:flutter/material.dart';
import 'package:codeiiest/models/user.dart';
import 'package:codeiiest/services/auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  User _user = User();
  bool _isLoading = false;
  final Authenticator _auth = Authenticator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0E5EC),
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        elevation: 5.0,
        title: Row(
          children: <Widget>[
            Text(
              'Sign In',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              ' / CodeIIEST',
              style: TextStyle(fontWeight: FontWeight.w300),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
        child: ListView(
          children: <Widget>[
            Center(
                child: _isLoading
                    ? LinearProgressIndicator()
                    : SizedBox(height: 6.0)),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffa3b1c6),
                    offset: Offset(9.0, 9.0),
                    blurRadius: 16.0,
                  ),
                  BoxShadow(
                    color: Color(0xffffffff),
                    offset: Offset(-9.0, -9.0),
                    blurRadius: 16.0,
                  ),
                ],
              ),
              child: Card(
                color: Colors.indigo,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                elevation: 0.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 24.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Welcome",
                        style: TextStyle(fontSize: 36.0, color: Colors.white),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Text(
                        "Hello 👋\nSign in now to save your preferences, or you may do it later...",
                        style: TextStyle(fontSize: 16.0, color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      SignInButton(
                        Buttons.Google,
                        onPressed: () async {
                          setState(() {
                            this._isLoading = true;
                          });
                          await _auth.signInGoogle();
                        },
                      ),
                      FlatButton(
                        child: Text(
                          "SKIP",
                          style: TextStyle(color: Colors.amber[400]),
                        ),
                        onPressed: () {
                          _auth.signInAnon();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget coolBtn(String text, String path) {
//   return Container(
//     decoration: BoxDecoration(
//       boxShadow: [
//         BoxShadow(
//           color: Colors.greenAccent[100],
//           offset: Offset(0.0, 6.0),
//           blurRadius: 8.0,
//         ),
//       ],
//     ),
//     child: FlatButton(
//       child: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Text(
//           text,
//           style: TextStyle(
//             fontSize: 18.0,
//           ),
//         ),
//       ),
//       color: Colors.greenAccent,
//       onPressed: () => Navigator.pushNamed(context, path),
//       splashColor: Colors.greenAccent[100],
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(8.0)),
//       ),
//     ),
//   );
// }
