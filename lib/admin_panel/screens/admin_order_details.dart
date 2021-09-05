import 'package:book_store/admin_panel/screens/admin_home_screen.dart';
import 'package:book_store/admin_panel/screens/admin_orders.dart';
import 'package:book_store/data_model/address.dart';
import 'package:book_store/screens/address.dart';
import 'package:book_store/service/service.dart';
import 'package:book_store/shared/circular.dart';
import 'package:book_store/shared/show_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

String getOrderId = "";

class AdminOrderDetails extends StatelessWidget {
  final String orderID;
  final String orderBy;
  final String addressID;

  AdminOrderDetails(
      {required this.orderID, required this.orderBy, required this.addressID});
  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () => SystemNavigator.pop(),
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: BookStore.firebaseFirestore!
              .collection(BookStore.orders)
              .doc(getOrderId)
              .get(),
          builder: (c, snapshot) {
            Map data = Map();
            if (snapshot.hasData) {
              data = snapshot.data!.data() as Map<dynamic, dynamic>;
            }
            return snapshot.hasData
                ? Container(
                    child: Column(
                      children: [
                        AdminOrderStatus(
                          status: data[BookStore.isPlacedOrder],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Text(
                                "Order ID: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                getOrderId,
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 11.0,
                                  color: Colors.black87,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Text(
                                "Payment ID: ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              Text(
                                data['payementDetails'],
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.black87,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Total Amount: ₹ " +
                                  data[BookStore.totalMoney].toString(),
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Order Time: " +
                                DateFormat.yMd().add_jm().format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(data["orderTime"]),
                                      ),
                                    ),
                            style:
                                TextStyle(color: Colors.grey, fontSize: 16.0),
                          ),
                        ),
                        FutureBuilder<QuerySnapshot>(
                          future: BookStore.firebaseFirestore!
                              .collection("books")
                              .where("title", whereIn: data[BookStore.bookID])
                              .get(),
                          builder: (c, dataSnapshot) {
                            return dataSnapshot.hasData
                                ? ShowOrderCard(
                                    noOfOrderedBook:
                                        dataSnapshot.data!.docs.length,
                                    bookData: dataSnapshot.data!.docs,
                                    //orderID: orderID,
                                  )
                                : Center(
                                    child: circularProgress(),
                                  );
                          },
                        ),
                        FutureBuilder<DocumentSnapshot>(
                          future: BookStore.firebaseFirestore!
                              .collection(BookStore.users)
                              .doc(orderBy)
                              .collection(BookStore.userAddress)
                              .doc(addressID)
                              .get(),
                          builder: (c, snap) {
                            return snap.hasData
                                ? AdminShippingDetails(
                                    addressDataModel: AddressDataModel.fromJson(
                                        snap.data!.data()
                                            as Map<String, dynamic>))
                                : Center(
                                    child: circularProgress(),
                                  );
                          },
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}

class AdminOrderStatus extends StatelessWidget {
  final bool status;

  AdminOrderStatus({required this.status});

  @override
  Widget build(BuildContext context) {
    String message;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? message = "Successfully" : message = "Un Successfull";

    return Container(
      margin: EdgeInsets.only(top: 10.0),
      height: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20.0,
          ),
          Text(
            "Order Shipped " + message,
            style: TextStyle(color: Colors.black),
          ),
          SizedBox(
            width: 5.0,
          ),
          CircleAvatar(
            radius: 8.0,
            backgroundColor: Colors.green,
            child: Icon(
              iconData,
              color: Colors.white,
              size: 14.0,
            ),
          )
        ],
      ),
    );
  }
}

class AdminShippingDetails extends StatelessWidget {
  final AddressDataModel addressDataModel;
  AdminShippingDetails({required this.addressDataModel});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Shipment Details",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
          width: screenWidth,
          child: Table(
            children: [
              TableRow(children: [
                Infotext(
                  message: "Name",
                ),
                Text(addressDataModel.name.toString()),
              ]),
              TableRow(children: [
                Infotext(
                  message: "Phone Number",
                ),
                Text(addressDataModel.phoneNumber.toString()),
              ]),
              TableRow(children: [
                Infotext(
                  message: "House Number",
                ),
                Text(addressDataModel.houseNumber.toString()),
              ]),
              TableRow(children: [
                Infotext(
                  message: "City",
                ),
                Text(addressDataModel.city.toString()),
              ]),
              TableRow(children: [
                Infotext(
                  message: "State",
                ),
                Text(addressDataModel.state.toString()),
              ]),
              TableRow(
                children: [
                  Infotext(
                    message: "Pin Code",
                  ),
                  Text(addressDataModel.pincode.toString()),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
