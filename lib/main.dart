import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:book_store/providers/address_changer.dart';
import 'package:book_store/providers/booked_Books_quantity.dart';
import 'package:book_store/providers/count_book_on_cart.dart';
import 'package:book_store/providers/total_amount.dart';
import 'package:book_store/screens/home_screen.dart';
import 'package:book_store/screens/login.dart';
import 'package:book_store/screens/register.dart';
import 'package:book_store/service/service.dart';
import 'package:book_store/shared/circular.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  BookStore.auth = FirebaseAuth.instance;
  BookStore.sharedPreferences = await SharedPreferences.getInstance();
  BookStore.firebaseFirestore = FirebaseFirestore.instance;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c) => CountBookOnCart()),
        ChangeNotifierProvider(create: (c) => BookedBooksQuantity()),
        ChangeNotifierProvider(create: (c) => ChangeAddress()),
        ChangeNotifierProvider(create: (c) => TotalMoney()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Book Store',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    splashScreenDisplay();
  }

  splashScreenDisplay() {
    Timer(Duration(seconds: 5), () async {
      if (await BookStore.auth!.currentUser != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => HomeScreen()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => Login()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('images/book.png'),
          SpinKitThreeBounce(color: Colors.red),
        ],
      ),
    );
  }
}
