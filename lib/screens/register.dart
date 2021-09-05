import 'dart:io';
import 'package:book_store/screens/background.dart';
import 'package:book_store/screens/home_screen.dart';
import 'package:book_store/screens/login.dart';
import 'package:book_store/service/service.dart';
import 'package:book_store/shared/error.dart';
import 'package:book_store/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:book_store/shared/custom_textinput.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:email_auth/email_auth.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _otp = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _cpass = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String userDpUrl = '';
  XFile? _xFile;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Background(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Form(
                        key: _key,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                "REGISTER",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2661FA),
                                    fontSize: 36),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            CustomTextInputs(
                              controller: _name,
                              hintText: "Full Name",
                              isPassword: false,
                              iconData: Icons.person,
                            ),
                            CustomTextInputs(
                              controller: _email,
                              hintText: "Email ID",
                              isPassword: false,
                              iconData: Icons.email,
                            ),
                            CustomTextInputs(
                                controller: _pass,
                                hintText: "Password (at least 6 chars)",
                                isPassword: true,
                                iconData: Icons.lock),
                            CustomTextInputs(
                              controller: _cpass,
                              hintText: "Confirm Password",
                              isPassword: true,
                              iconData: Icons.lock,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text("Select your Profile Picture."),
                                InkWell(
                                  onTap: () async {
                                    XFile? pickedImage = await _picker
                                        .pickImage(source: ImageSource.gallery);
                                    setState(() {
                                      _xFile = pickedImage;
                                    });
                                  },
                                  child: CircleAvatar(
                                    radius: size.width * 0.10,
                                    backgroundColor: Colors.white24,
                                    backgroundImage: _xFile == null
                                        ? null
                                        : Image.file(File(_xFile!.path)).image,
                                    child: _xFile == null
                                        ? Icon(
                                            Icons.add_photo_alternate,
                                            size: size.width * 0.15,
                                            color: Colors.red,
                                          )
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 0.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  checkValidation();
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(80.0)),
                                  padding: const EdgeInsets.all(0),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50.0,
                                  width: size.width * 0.5,
                                  decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.circular(80.0),
                                      color: Colors.redAccent),
                                  padding: const EdgeInsets.all(0),
                                  child: Text(
                                    "SIGN UP",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
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
                                          builder: (context) => Login()))
                                },
                                child: Text(
                                  "Already Have an Account? Sign in",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2661FA)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkValidation() async {
    _pass.text == _cpass.text
        ? _name.text.isNotEmpty &&
                _email.text.isNotEmpty &&
                _pass.text.isNotEmpty &&
                _cpass.text.isNotEmpty
            ? _xFile == null
                ? showDialog(
                    context: context,
                    builder: (c) {
                      return ErrorDialog(message: "Please Select an Image");
                    })
                : sendOTP()
            : dialog("All Fields are required")
        : dialog("Password does not matches");
  }

  dialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(message: msg);
        });
  }

  saveUserDataToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(message: "Signing Up, please wait...");
        });

    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference = FirebaseStorage.instance.ref().child(imageName);
    UploadTask uploadTask = reference.putFile(File(_xFile!.path));
    TaskSnapshot taskSnapshot = await uploadTask;

    await taskSnapshot.ref.getDownloadURL().then((value) {
      userDpUrl = value;
    });
    _userRegistration();
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _userRegistration() async {
    User? firebaseUser;
    await _auth
        .createUserWithEmailAndPassword(
            email: _email.text.trim(), password: _pass.text.trim())
        .then((auth) {
      firebaseUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });
    if (firebaseUser != null) {
      saveUserDataToFirebaseFirestore(firebaseUser).then((value) {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => HomeScreen()));
      });
    }
  }

  Future saveUserDataToFirebaseFirestore(User? fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser!.uid).set({
      "uid": fUser.uid,
      "userEmail": fUser.email,
      "userName": _name.text.trim(),
      "avatarUrl": userDpUrl,
      BookStore.userCart: ["garbageValue"],
    });

    await BookStore.sharedPreferences!.setString("uid", fUser.uid);
    await BookStore.sharedPreferences!
        .setString(BookStore.userEmail, fUser.email!);
    await BookStore.sharedPreferences!
        .setString(BookStore.userName, _name.text);
    await BookStore.sharedPreferences!
        .setString(BookStore.avatarUrl, userDpUrl);
    await BookStore.sharedPreferences!
        .setStringList(BookStore.userCart, ["garbageValue"]);
  }

  Widget buildBottomSheet(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        height: 300.0,
        child: Column(
          children: [
            Text(
              "An OTP has been sent to your email.",
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "verify OTP",
              style: TextStyle(fontSize: 18.0),
            ),
            TextField(
              controller: _otp,
              keyboardType: TextInputType.number,
              autofocus: true,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15.0,
            ),
            ElevatedButton(
              onPressed: () {
                verifyOTP();
              },
              child: Text("Verify OTP"),
              style: ElevatedButton.styleFrom(
                  primary: Color(0xff19b38d), fixedSize: Size(200, 50)),
            )
          ],
        ),
      ),
    );
  }

  void sendOTP() async {
    var res = await EmailAuth(sessionName: "Email Verification on Book Store")
        .sendOtp(recipientMail: _email.text);
    if (res) {
      Fluttertoast.showToast(msg: "OTP sent successfully.");
      showModalBottomSheet(context: context, builder: buildBottomSheet);
    } else {
      Fluttertoast.showToast(msg: "Couldn't sent OTP");
    }
  }

  void verifyOTP() async {
    var res = await EmailAuth(sessionName: "Email Verification on Book Store")
        .validateOtp(recipientMail: _email.text, userOtp: _otp.text);

    if (res) {
      Fluttertoast.showToast(msg: "OTP Verified.");
      Navigator.pop(context);
      saveUserDataToStorage();
    } else {
      Fluttertoast.showToast(msg: "Invalid OTP.");
    }
  }
}
