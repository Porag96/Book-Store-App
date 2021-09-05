import 'package:book_store/admin_panel/admin_login.dart';
import 'package:book_store/screens/home_screen.dart';
import 'package:book_store/screens/register.dart';
import 'package:book_store/service/service.dart';
import 'package:book_store/shared/custom_textinput.dart';
import 'package:book_store/shared/error.dart';
import 'package:book_store/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            //height: 600.0,
            child: Column(
              children: [
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          left: 30,
                          width: 80,
                          height: 200,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/light-1.png'))),
                          )),
                      Positioned(
                          left: 140,
                          width: 80,
                          height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/light-2.png'))),
                          )),
                      Positioned(
                          right: 40,
                          top: 40,
                          width: 80,
                          height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/clock.png'))),
                          )),
                      Positioned(
                          child: Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        Form(
                          key: _key,
                          child: Column(
                            children: [
                              CustomTextInputs(
                                controller: _email,
                                hintText: "Email ID",
                                isPassword: false,
                                iconData: Icons.email,
                              ),
                              CustomTextInputs(
                                  controller: _pass,
                                  hintText: "Password",
                                  isPassword: true,
                                  iconData: Icons.lock),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        InkWell(
                          onTap: () {
                            // checkValidation();
                            _email.text.isNotEmpty && _pass.text.isNotEmpty
                                ? userLogin()
                                : showDialog(
                                    context: context,
                                    builder: (c) {
                                      return ErrorDialog(
                                          message:
                                              "Please Enter Email & Password");
                                    });
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(143, 148, 251, 1),
                                  Color.fromRGBO(143, 148, 251, .6),
                                ])),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          child: GestureDetector(
                            onTap: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register()))
                            },
                            child: Text(
                              "New user? Create Account",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2661FA)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Divider(
                            color: Colors.pink,
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => AdminSignInPage()));
                          },
                          child: Text(
                            "Admin Login",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void userLogin() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(message: "Logging in, please wait...");
        });

    User? firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _email.text.trim(),
      password: _pass.text.trim(),
    )
        .then((authenticatedUser) {
      firebaseUser = authenticatedUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: error.message.toString());
          });
    });

    if (firebaseUser != null) {
      fetchUserData(firebaseUser).then((s) {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => HomeScreen()));
      });
    }
  }

  Future fetchUserData(User? fUser) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(fUser!.uid)
        .get()
        .then((dataSnapshot) async {
      await BookStore.sharedPreferences!
          .setString("uid", dataSnapshot.data()![BookStore.userID]);
      await BookStore.sharedPreferences!.setString(
          BookStore.userEmail, dataSnapshot.data()![BookStore.userEmail]);
      await BookStore.sharedPreferences!.setString(
          BookStore.userName, dataSnapshot.data()![BookStore.userName]);
      await BookStore.sharedPreferences!.setString(
          BookStore.avatarUrl, dataSnapshot.data()![BookStore.avatarUrl]);
      List<String> cartList =
          dataSnapshot.data()![BookStore.userCart].cast<String>();
      await BookStore.sharedPreferences!
          .setStringList(BookStore.userCart, cartList);
    });
  }
}
