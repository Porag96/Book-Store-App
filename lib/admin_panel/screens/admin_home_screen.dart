import 'package:book_store/admin_panel/admin_login.dart';
import 'package:book_store/admin_panel/screens/admin_orders.dart';
import 'package:book_store/admin_panel/screens/view_books.dart';
import 'package:book_store/admin_panel/screens/view_users.dart';
import 'package:book_store/service/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with AutomaticKeepAliveClientMixin<AdminHomeScreen> {
  bool get wantKeepAlive => true;
  //final String controller='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          color: Colors.deepPurpleAccent,
        ),
        title: Text(
          'Admin Home Page',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (c) => AdminSignInPage()));
            },
          )
        ],
      ),
      //body: AdminOrders(),
      body: SafeArea(
        child: Container(
          child: GridView.count(
            crossAxisCount: 2,
            //crossAxisSpacing: 10.0,
            //mainAxisSpacing: 10.0,
            children: [
              CountInfos(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => ViewUsers()));
                },
                controller: "Users",
                iconData: Icons.people_alt,
                count: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .snapshots(),
                  builder: (context, snap) {
                    return Text(
                      snap.data!.docs.length.toString(),
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    );
                  },
                ),
              ),
              CountInfos(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => ViewBooks()));
                },
                controller: "Books",
                iconData: Icons.book,
                count: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("books")
                      .snapshots(),
                  builder: (context, snap) {
                    return Text(
                      snap.data!.docs.length.toString(),
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    );
                  },
                ),
              ),
              CountInfos(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => AdminOrders()));
                },
                controller: "Orders",
                iconData: Icons.shopping_basket,
                count: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("orders")
                      .snapshots(),
                  builder: (context, snap) {
                    return Text(
                      snap.data!.docs.length.toString(),
                      style: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CountInfos extends StatelessWidget {
  final String controller;
  final IconData iconData;
  final StreamBuilder<QuerySnapshot<Object?>> count;
  final VoidCallback onPressed;

  CountInfos(
      {required this.controller,
      required this.iconData,
      required this.count,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2.0,
                  spreadRadius: 0.0,
                  offset: Offset(1, 1),
                )
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconData,
                    color: Colors.black54,
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    controller,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              count
            ],
          ),
        ),
      ),
    );
  }
}
