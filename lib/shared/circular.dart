import 'package:flutter/material.dart';

circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.only(top: 22.0),
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.red),
    ),
  );
}
