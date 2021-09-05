import 'package:book_store/providers/count_book_on_cart.dart';
import 'package:book_store/providers/total_amount.dart';
import 'package:book_store/screens/home_screen.dart';
import 'package:book_store/service/service.dart';
import 'package:book_store/shared/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Order extends StatefulWidget {
  final String addressId;
  final double totalMoney;
  final String phoneNumber;

  Order({
    required this.addressId,
    required this.totalMoney,
    required this.phoneNumber,
  });

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  Razorpay? _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay?.clear();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    String res = response.paymentId as String;
    addOrderDetails(res);
    sendMail(res);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    //String message = response.message as String;
    Fluttertoast.showToast(msg: "Payment Failed");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    Fluttertoast.showToast(msg: response.walletName as String);
  }

  checkout() async {
    var options = {
      'key': 'rzp_test_BR5ma4bqFHp1n0',
      'amount': widget.totalMoney * 100, //in the smallest currency sub-unit.
      'name': 'Book Store.',
      //'image': 'images/cod.png',
      //'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
      'description': 'Make Payment to place order successfully',
      'timeout': 180, // in seconds
      'prefill': {
        'contact': widget.phoneNumber,
        'email': BookStore.sharedPreferences!.getString(BookStore.userEmail),
      },
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(title: Text("Oder")),
      body: Material(
        child: Container(
          child: Center(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 20.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Color(0xff19b38d),
                              child: Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 15.0,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Divider(
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Color(0xff19b38d),
                              child: Icon(
                                Icons.done,
                                color: Colors.white,
                                size: 15.0,
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Divider(
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            CircleAvatar(
                              radius: 10,
                              backgroundColor: Color(0xff19b38d),
                              child: Text(
                                "3",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Address"),
                            Text("Order Summery"),
                            Text("Payment")
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 50.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                              0.5, 0.5), // shadow direction: bottom right
                        ),
                      ],
                    ),
                    height: 100.0,
                    child: Center(
                      child: Consumer<TotalMoney>(
                        builder: (context, amountProvider, c) {
                          return Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              "Total Amount: ₹ ${amountProvider.total.toString()}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w500),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Color(0xff19b38d),
                        fixedSize: Size(250, 50)),
                    child: Center(
                        child: Text(
                      "Make Payment",
                      style: TextStyle(color: Colors.white),
                    )),
                    onPressed: () {
                      checkout();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  addOrderDetails(String res) {
    saveUserOrderDetails({
      BookStore.userAddressID: widget.addressId,
      BookStore.totalMoney: widget.totalMoney,
      "orderBy": BookStore.sharedPreferences!.getString(BookStore.userID),
      BookStore.bookID:
          BookStore.sharedPreferences!.getStringList(BookStore.userCart),
      BookStore.payementDetails: res,
      BookStore.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      BookStore.isPlacedOrder: true,
    });

    saveUserOrderDetailsForAdmin({
      BookStore.userAddressID: widget.addressId,
      BookStore.totalMoney: widget.totalMoney,
      "orderBy": BookStore.sharedPreferences!.getString(BookStore.userID),
      BookStore.bookID:
          BookStore.sharedPreferences!.getStringList(BookStore.userCart),
      BookStore.payementDetails: res,
      BookStore.orderTime: DateTime.now().millisecondsSinceEpoch.toString(),
      BookStore.isPlacedOrder: true,
    }).whenComplete(() {
      emptyTheCart();
    });
  }

  emptyTheCart() {
    BookStore.sharedPreferences!
        .setStringList(BookStore.userCart, ["garbageValue"]);
    List tempCartList =
        BookStore.sharedPreferences!.getStringList(BookStore.userCart) as List;

    FirebaseFirestore.instance
        .collection("users")
        .doc(BookStore.sharedPreferences!.getString(BookStore.userID))
        .update({
      BookStore.userCart: tempCartList,
    }).then((value) {
      BookStore.sharedPreferences!
          .setStringList(BookStore.userCart, tempCartList as List<String>);
      Provider.of<CountBookOnCart>(context, listen: false).countBook();
    });
    Fluttertoast.showToast(msg: "Order Placed Successfully!!");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (c) => HomeScreen()));
  }

  Future saveUserOrderDetails(Map<String, dynamic> data) async {
    await BookStore.firebaseFirestore!
        .collection(BookStore.users)
        .doc(BookStore.sharedPreferences!.getString(BookStore.userID))
        .collection(BookStore.orders)
        .doc(BookStore.sharedPreferences!.getString(BookStore.userID)! +
            data['orderTime'])
        .set(data);
  }

  Future saveUserOrderDetailsForAdmin(Map<String, dynamic> data) async {
    await BookStore.firebaseFirestore!
        .collection(BookStore.orders)
        .doc(BookStore.sharedPreferences!.getString(BookStore.userID)! +
            data['orderTime'])
        .set(data);
  }

  void sendMail(String res) async {
    String username = 'poragtheracer6@gmail.com';
    String password = 'Porag@1996';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Book Store')
      ..recipients
          .add(BookStore.sharedPreferences!.getString(BookStore.userEmail))
      ..subject =
          'Hi ${BookStore.sharedPreferences!.getString(BookStore.userName)}'
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html =
          "<h1>Order Successfully placed</h1>\n<p>Your order will be delivered within 7 working days.</p>\n<p>We are pleased to confirm your order</p>\n<p>Your Payment ID is: $res</p>\n<p>Thank you for shopping with us.</p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
