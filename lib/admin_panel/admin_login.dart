import 'package:book_store/admin_panel/screens/admin_home_screen.dart';
import 'package:book_store/screens/login.dart';
import 'package:book_store/shared/custom_textinput.dart';
import 'package:book_store/shared/error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AdminSignInScreen(),
    );
  }
}

class AdminSignInScreen extends StatefulWidget {
  @override
  _AdminSignInScreenState createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  final TextEditingController _adminIDTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 100.0, horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset('images/alogin.jpg'),
            SizedBox(
              height: 30.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextInputs(
                    controller: _adminIDTextEditingController,
                    iconData: Icons.person,
                    hintText: "ID",
                    isPassword: false,
                  ),
                  CustomTextInputs(
                    controller: _passwordTextEditingController,
                    iconData: Icons.lock_open_outlined,
                    hintText: "Password",
                    isPassword: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () {
                _adminIDTextEditingController.text.isNotEmpty &&
                        _passwordTextEditingController.text.isNotEmpty
                    ? adminLogin()
                    : showDialog(
                        context: context,
                        builder: (c) {
                          return ErrorDialog(
                              message: "Please Enter ID & Password");
                        });
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                fixedSize: Size(240, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            Container(
              height: 1.0,
              width: _screenWidth * 0.8,
              color: Colors.pink,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (c) => Login()));
                },
                child: Text(
                  "User Login",
                  style: TextStyle(color: Colors.red),
                )),
          ],
        ),
      ),
    );
  }

  adminLogin() {
    FirebaseFirestore.instance.collection("admins").get().then((snapshot) {
      snapshot.docs.forEach((result) {
        if (result.data()["id"] != _adminIDTextEditingController.text.trim()) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Invalid ID")));
        } else if (result.data()["password"] !=
            _passwordTextEditingController.text.trim()) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Invalid ID")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Welcome " + result.data()["name"]),
          ));
          setState(() {
            _adminIDTextEditingController.text = "";
            _passwordTextEditingController.text = "";
          });

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (c) => AdminHomeScreen()));
        }
      });
    });
  }
}
