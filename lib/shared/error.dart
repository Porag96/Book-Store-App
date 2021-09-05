import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  String message;
  ErrorDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message),
      actions: <Widget>[
        Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                primary: Color(0xff19b38d),
                fixedSize: Size(200, 40) // background
                ),
            child: Text("OK"),
          ),
        )
      ],
    );
  }
}
