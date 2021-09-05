import 'package:book_store/data_model/books.dart';
import 'package:book_store/providers/count_book_on_cart.dart';
import 'package:book_store/providers/total_amount.dart';
import 'package:book_store/screens/address.dart';
import 'package:book_store/screens/book_details.dart';
import 'package:book_store/screens/home_screen.dart';
import 'package:book_store/service/service.dart';
import 'package:book_store/shared/circular.dart';
import 'package:book_store/shared/custom_appbar.dart';
import 'package:book_store/shared/custom_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double totalMoney = 0;

  @override
  void initState() {
    super.initState();
    totalMoney = 0;
    Provider.of<TotalMoney>(context, listen: false).display(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (BookStore.sharedPreferences!
                  .getStringList(BookStore.userCart)!
                  .length ==
              1) {
            Fluttertoast.showToast(msg: "Your Cart is Empty");
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (c) => AddressScreen(totalMoney: totalMoney)));
          }
        },
        label: Text("Check Out"),
        backgroundColor: Color(0xff19b38d),
        icon: Icon(Icons.arrow_right),
      ),
      appBar: CustomAppbar(
        title: Text("Cart"),
      ),
      drawer: CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Consumer2<TotalMoney, CountBookOnCart>(
              builder: (context, amountProvider, cartProvider, c) {
                return Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: cartProvider.count == 0
                        ? Container()
                        : Text(
                            "Total Price: ₹ ${amountProvider.total.toString()}",
                            // "",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500),
                          ),
                  ),
                );
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: BookStore.firebaseFirestore!
                .collection("books")
                .where("title",
                    whereIn: BookStore.sharedPreferences!
                        .getStringList(BookStore.userCart))
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : snapshot.data!.docs.length == 0
                      ? buildCart()
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              BookModel bookModel = BookModel.fromJson(
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>);

                              if (index == 0) {
                                totalMoney = 0;
                                totalMoney = bookModel.price + totalMoney;
                              } else {
                                totalMoney = bookModel.price + totalMoney;
                              }

                              if (snapshot.data!.docs.length - 1 == index) {
                                WidgetsBinding.instance!
                                    .addPostFrameCallback((timeStamp) {
                                  Provider.of<TotalMoney>(context,
                                          listen: false)
                                      .display(totalMoney);
                                });
                              }

                              return fetchBookInfo(bookModel, context,
                                  removeCartFunction: () =>
                                      removeBookFromCart(bookModel.title));
                            },
                            childCount: snapshot.hasData
                                ? snapshot.data!.docs.length
                                : 0,
                          ),
                        );
            },
          )
        ],
      ),
    );
  }

  Widget fetchBookInfo(BookModel bookModel, BuildContext context,
      {Color background: Colors.red, removeCartFunction}) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => BookDetails(
                      bookModel: bookModel,
                    )));
      },
      splashColor: Colors.red,
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
          height: 170.0,
          //width: width,
          child: Row(
            children: [
              Image.network(
                bookModel.bookPhotoUrl,
                height: 140.0,
                width: 140.0,
              ),
              SizedBox(
                width: 8.0,
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
                                fontWeight: FontWeight.bold,
                              ),
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
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
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
                              Text("Category"),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                bookModel.category,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
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
                                    "Price: ",
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  Text(
                                    "₹",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  Text(
                                    bookModel.price.toString(),
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    // Flexible(
                    //   child: Container(),
                    // ),
                    //to implement cart item add/remove feature
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          removeCartFunction();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (c) => HomeScreen()));
                        },
                        icon: Icon(
                          Icons.remove_shopping_cart,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.red,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildCart() {
    return SliverToBoxAdapter(
      child: Card(
        elevation: 0.0,
        color: Colors.white24,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/cart.png'),
            SizedBox(
              height: 30.0,
            ),
            Text(
              "Your Cart is Empty",
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Your have no items in your shopping cart.",
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "Let's go Buy Something!",
              style: TextStyle(color: Colors.black54),
            ),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (c) => HomeScreen()));
              },
              child: Text("Shop Now"),
              style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  primary: Color(0xff19b38d),
                  fixedSize: Size(240, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50))),
            ),
          ],
        ),
      ),
    );
  }

  removeBookFromCart(String titleAsId) {
    List<String> tempCart =
        BookStore.sharedPreferences!.getStringList(BookStore.userCart)!;
    tempCart.remove(titleAsId);

    BookStore.firebaseFirestore!
        .collection(BookStore.users)
        .doc(BookStore.sharedPreferences!.getString(BookStore.userID))
        .update({
      BookStore.userCart: tempCart,
    }).then((value) {
      Fluttertoast.showToast(msg: "Book Removed from Cart Successfully.");

      BookStore.sharedPreferences!.setStringList(BookStore.userCart, tempCart);

      Provider.of<CountBookOnCart>(context, listen: false).countBook();

      totalMoney = 0;
    });
  }
}
