import 'package:book_store/data_model/address.dart';
import 'package:book_store/main.dart';
import 'package:book_store/screens/address.dart';
import 'package:book_store/screens/home_screen.dart';
import 'package:book_store/service/service.dart';
import 'package:book_store/shared/circular.dart';
import 'package:book_store/shared/show_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

String getOrderId = "";

class OrderDetails extends StatelessWidget {
  final String orderID;
  OrderDetails({required this.orderID});
  @override
  Widget build(BuildContext context) {
    getOrderId = orderID;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff19b38d),
        // iconTheme: IconThemeData(
        //   color: Colors.lightBlueAccent,
        // ),
        //backgroundColor: Colors.white30,
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
              .collection(BookStore.users)
              .doc(BookStore.sharedPreferences!.getString(BookStore.userID))
              .collection(BookStore.orders)
              .doc(orderID)
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
                        OrderStatus(
                          status: data[BookStore.isPlacedOrder],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                                  fontSize: 11.0,
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
                              "Payment ID: " + data["payementDetails"],
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
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
                              .doc(BookStore.sharedPreferences!
                                  .getString(BookStore.userID))
                              .collection(BookStore.userAddress)
                              .doc(data[BookStore.userAddressID])
                              .get(),
                          builder: (c, snap) {
                            return snap.hasData
                                ? ShipmentAddressDetails(
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

class OrderStatus extends StatelessWidget {
  final bool status;

  OrderStatus({required this.status});

  @override
  Widget build(BuildContext context) {
    String message;
    IconData iconData;

    status ? iconData = Icons.done : iconData = Icons.cancel;
    status ? message = "Successfully" : message = "Un Successfull";

    return Container(
      //margin: EdgeInsets.only(top: 10.0),
      height: 60.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Order Placed " + message,
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

class ShipmentAddressDetails extends StatelessWidget {
  final AddressDataModel addressDataModel;
  ShipmentAddressDetails({required this.addressDataModel});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 5.0,
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Text(
            "Expected Delivery in 7 Days",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.all(10.0),
        //   child: Center(
        //     child: InkWell(
        //       onTap: () {
        //         userConfirmationOfDelivery(context, getOrderId);
        //       },
        //       child: Container(
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(25.0),
        //           color: Colors.deepPurple,
        //         ),
        //         width: MediaQuery.of(context).size.width - 40.0,
        //         height: 50.0,
        //         child: Center(
        //           child: Text(
        //             "Confirm Recieved Order",
        //             style: TextStyle(
        //                 color: Colors.white,
        //                 fontSize: 18.0,
        //                 fontWeight: FontWeight.bold),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  userConfirmationOfDelivery(BuildContext context, String userOrderId) {
    BookStore.firebaseFirestore!
        .collection(BookStore.users)
        .doc(BookStore.sharedPreferences!.getString(BookStore.userID))
        .collection(BookStore.orders)
        .doc(userOrderId)
        .delete();

    getOrderId = "";

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (c) => HomeScreen()));

    Fluttertoast.showToast(msg: "Order has been received");
  }
}
