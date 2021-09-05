import 'package:book_store/data_model/books.dart';
import 'package:book_store/providers/count_book_on_cart.dart';
import 'package:book_store/service/service.dart';
import 'package:book_store/shared/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class BookDetails extends StatefulWidget {
  final BookModel bookModel;
  BookDetails({required this.bookModel});
  @override
  _BookDetailsState createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  int bookQuantity = 1;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppbar(
        title: Text("Book Details"),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                child: Text("Add to Cart"),
                onPressed: () {
                  isBookOnCart(widget.bookModel.title, context);
                },
                style: ElevatedButton.styleFrom(
                    primary: Color(0xff19b38d), fixedSize: Size(220, 50)),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 10.0),
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300.0,
                  child: Center(
                    child: Image.network(widget.bookModel.bookPhotoUrl),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.bookModel.title,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "By " + widget.bookModel.authorName,
                        style: TextStyle(fontSize: 15.0, color: Colors.black54),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Category: " + widget.bookModel.category,
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "Abouth this Book",
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Text(
                          widget.bookModel.description,
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "₹" + widget.bookModel.price.toString(),
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        "FREE Delivery on your Order",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      // SizedBox(
                      //   height: 10.0,
                      // )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void isBookOnCart(String titleAsID, BuildContext context) {
    BookStore.sharedPreferences!
            .getStringList(BookStore.userCart)!
            .contains(titleAsID)
        ? Fluttertoast.showToast(msg: "Book is already in Cart.")
        : addBookToCart(titleAsID, context);
  }

  addBookToCart(String titleAsID, BuildContext context) {
    List<String> temporaryBookList =
        BookStore.sharedPreferences!.getStringList(BookStore.userCart)!;
    temporaryBookList.add(titleAsID);

    BookStore.firebaseFirestore!
        .collection(BookStore.users)
        .doc(BookStore.sharedPreferences!.getString(BookStore.userID))
        .update({
      BookStore.userCart: temporaryBookList,
    }).then((value) {
      Fluttertoast.showToast(msg: "Book Added to Cart Successfully.");

      BookStore.sharedPreferences!
          .setStringList(BookStore.userCart, temporaryBookList);

      Provider.of<CountBookOnCart>(context, listen: false).countBook();
    });
  }
}
