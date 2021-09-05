import 'package:book_store/admin_panel/screens/admin_order_details.dart';
import 'package:book_store/data_model/books.dart';
import 'package:book_store/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '';

int counter = 0;

class AdminOrderCard extends StatelessWidget {
  final int noOfOrderedBook;
  final List<DocumentSnapshot> bookData;
  final String orderID;
  final String addressID;
  final String orderBy;

  AdminOrderCard(
      {required this.noOfOrderedBook,
      required this.bookData,
      required this.orderID,
      required this.addressID,
      required this.orderBy});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => AdminOrderDetails(
                    orderID: orderID, orderBy: orderBy, addressID: addressID)));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(0.5, 0.5), // shadow direction: bottom right
            )
          ],
        ),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: noOfOrderedBook * 170.0,
        child: ListView.builder(
          itemCount: noOfOrderedBook,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (c, index) {
            BookModel bookModel = BookModel.fromJson(
                bookData[index].data() as Map<String, dynamic>);
            return fetchOrderInfo(bookModel, context);
          },
        ),
      ),
    );
  }

  Widget fetchOrderInfo(BookModel bookModel, BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Container(
      height: 160.0,
      width: width,
      child: Row(
        children: [
          Image.network(
            bookModel.bookPhotoUrl,
            //width: 180.0,
            height: 145.0,
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Text(
                          bookModel.title,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Text("By"),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            bookModel.authorName,
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          Text(
                            "Category:",
                            style: TextStyle(color: Colors.black54),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            bookModel.category,
                            style: TextStyle(
                                color: Colors.black54, fontSize: 14.0),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Text(
                                "Total Price: ",
                                style: TextStyle(color: Colors.black54),
                              ),
                              Text(
                                "₹",
                                style: TextStyle(color: Colors.black54),
                              ),
                              Text(
                                bookModel.price.toString(),
                                style: TextStyle(color: Colors.black54),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Flexible(
                  child: Container(),
                  //to implement cart item
                ),
                Divider(
                  height: 5.0,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
