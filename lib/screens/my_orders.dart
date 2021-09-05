import 'package:book_store/service/service.dart';
import 'package:book_store/shared/circular.dart';
import 'package:book_store/shared/show_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Color(0xff19b38d),
        title: Text("My Orders"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app_rounded),
            onPressed: () {
              SystemNavigator.pop();
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: BookStore.firebaseFirestore!
            .collection(BookStore.users)
            .doc(BookStore.sharedPreferences!.getString(BookStore.userID))
            .collection(BookStore.orders)
            .orderBy('orderTime', descending: true)
            .snapshots(),
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
                            ? ShowOrderCard(
                                noOfOrderedBook: snap.data!.docs.length,
                                bookData: snap.data!.docs,
                                orderID: snapshot.data!.docs[index].id,
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
}
