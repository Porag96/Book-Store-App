import 'package:book_store/data_model/address.dart';
import 'package:book_store/providers/address_changer.dart';
import 'package:book_store/screens/add_address.dart';
import 'package:book_store/screens/order.dart';
import 'package:book_store/service/service.dart';
import 'package:book_store/shared/circular.dart';
import 'package:book_store/shared/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  final double totalMoney;

  AddressScreen({required this.totalMoney});
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: Text("Address"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Select Address",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Consumer<ChangeAddress>(builder: (context, address, c) {
            return Flexible(
              child: StreamBuilder<QuerySnapshot>(
                stream: BookStore.firebaseFirestore!
                    .collection(BookStore.users)
                    .doc(BookStore.sharedPreferences!
                        .getString(BookStore.userID))
                    .collection(BookStore.userAddress)
                    .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(
                          child: circularProgress(),
                        )
                      : snapshot.data!.docs.length == 0
                          ? savedAddressNotFound()
                          : ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return AddressCard(
                                  currentIndex: address.count,
                                  addressId: snapshot.data!.docs[index].id,
                                  totalAmount: widget.totalMoney,
                                  phoneNumber: snapshot.data!.docs[index]
                                      ['phoneNumber'],
                                  value: index,
                                  addressDataModel: AddressDataModel.fromJson(
                                      snapshot.data!.docs[index].data()
                                          as Map<String, dynamic>),
                                );
                              },
                            );
                },
              ),
            );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Add New Address"),
        backgroundColor: Color(0xff19b38d),
        icon: Icon(Icons.add_location),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => AddAddressScreen()));
        },
      ),
    );
  }

  savedAddressNotFound() {
    return Card(
      elevation: 0.0,
      color: Colors.white24,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 20.0,
          ),
          Image.asset(
            'images/adr.png',
            height: 300.0,
          ),
          SizedBox(
            height: 30.0,
          ),
          Text(
            "No Previous address has been saved",
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black54),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Add an Address to deliver your desired Book.",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class AddressCard extends StatefulWidget {
  final AddressDataModel addressDataModel;
  final int currentIndex;
  final int value;
  final String addressId;
  final double totalAmount;
  final String phoneNumber;

  AddressCard({
    required this.addressDataModel,
    required this.currentIndex,
    required this.addressId,
    required this.totalAmount,
    required this.value,
    required this.phoneNumber,
  });

  @override
  _AddressCardState createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        Provider.of<ChangeAddress>(context, listen: false)
            .displayAddressResult(widget.value);
      },
      child: Card(
        elevation: 2.0,
        //color: Colors.green.withOpacity(0.5),
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  groupValue: widget.currentIndex,
                  value: widget.value,
                  activeColor: Colors.red,
                  onChanged: (val) {
                    Provider.of<ChangeAddress>(context, listen: false)
                        .displayAddressResult(val as int);
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.0),
                      width: width * 0.8,
                      child: Table(
                        children: [
                          TableRow(children: [
                            Infotext(
                              message: "Name",
                            ),
                            Text(widget.addressDataModel.name.toString()),
                          ]),
                          TableRow(children: [
                            Infotext(
                              message: "Phone Number",
                            ),
                            Text(
                                widget.addressDataModel.phoneNumber.toString()),
                          ]),
                          TableRow(children: [
                            Infotext(
                              message: "House Number",
                            ),
                            Text(
                                widget.addressDataModel.houseNumber.toString()),
                          ]),
                          TableRow(children: [
                            Infotext(
                              message: "City",
                            ),
                            Text(widget.addressDataModel.city.toString()),
                          ]),
                          TableRow(children: [
                            Infotext(
                              message: "State",
                            ),
                            Text(widget.addressDataModel.state.toString()),
                          ]),
                          TableRow(children: [
                            Infotext(
                              message: "Pin Code",
                            ),
                            Text(widget.addressDataModel.pincode.toString()),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            widget.value == Provider.of<ChangeAddress>(context).count
                ? InkWell(
                    onTap: () {
                      Route route = MaterialPageRoute(
                          builder: (c) => Order(
                                addressId: widget.addressId,
                                totalMoney: widget.totalAmount,
                                phoneNumber: widget.phoneNumber,
                              ));
                      Navigator.push(context, route);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff19b38d),
                      ),
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 50.0,
                      child: Center(
                        child: Text(
                          "Continue",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 10.0,
            )
          ],
        ),
      ),
    );
  }
}

class Infotext extends StatelessWidget {
  final message;
  Infotext({required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
