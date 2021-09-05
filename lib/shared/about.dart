import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff19b38d),
        title: Text("About"),
        centerTitle: true,
      ),
      body: Card(
        elevation: 0.0,
        color: Colors.white24,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/book.png'),
            SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "This is a Major Project to be submitted to the Dibrugarh "
                "University for the partial fulfilment of the Degree of MCA.",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(
              color: Colors.red,
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Developed By",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Porag jyoti Borah",
                  style: TextStyle(fontSize: 16.0),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
