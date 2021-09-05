import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  Background({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        //height: size.height,
        //height: 1000.0,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset("images/top1.png", width: size.width),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset("images/top2.png", width: size.width),
            ),
            Positioned(
              top: 50,
              right: 30,
              child: Image.asset("images/main.png", width: size.width * 0.35),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset("images/bottom1.png", width: size.width),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset("images/bottom2.png", width: size.width),
            ),
            child
          ],
        ),
      ),
    );
  }
}
