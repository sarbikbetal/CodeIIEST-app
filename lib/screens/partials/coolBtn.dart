import 'package:flutter/material.dart';

Widget coolBtn(String text) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.greenAccent[100],
          offset: Offset(0.0, 6.0),
          blurRadius: 8.0,
        ),
      ],
    ),
    child: FlatButton(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ),
      color: Colors.greenAccent,
      onPressed: () {},
      splashColor: Colors.greenAccent[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    ),
  );
}
