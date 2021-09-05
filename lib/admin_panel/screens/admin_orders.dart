import 'dart:io';

import 'package:book_store/admin_panel/screens/admin_order_card.dart';
import 'package:book_store/service/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminOrders extends StatefulWidget {
  @override
  _AdminOrdersState createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          "Orders Placed By Users",
          style: TextStyle(color: Colors.black54),
        ),
        centerTitle: true,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.lightBlueAccent,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("orders").snapshots(),
        builder: (c, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (c, index) {
                    return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("books")
                          .where("title",
                              whereIn: snapshot.data!.docs[index]
                                  .get(BookStore.bookID))
                          .get(),
                      builder: (c, snap) {
                        return snap.hasData
                            ? AdminOrderCard(
                                noOfOrderedBook: snap.data!.docs.length,
                                bookData: snap.data!.docs,
                                orderID: snapshot.data!.docs[index].id,
                                addressID: snapshot.data!.docs[index]
                                    .get("userAddressID"),
                                //check for userAddresssID
                                orderBy:
                                    snapshot.data!.docs[index].get("orderBy"),
                              )
                            : Center(
                                child: circularProgress(),
                              );
                      },
                    );
                  },
                )
              : Center(
                  child: circularProgress(),
                );
        },
      ),
    );
  }

  circularProgress() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 20.0),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.blue),
      ),
    );
  }
}
