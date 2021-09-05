import 'package:book_store/data_model/books.dart';
import 'package:book_store/providers/count_book_on_cart.dart';
import 'package:book_store/screens/book_details.dart';
import 'package:book_store/screens/cart.dart';
import 'package:book_store/screens/login.dart';
import 'package:book_store/service/service.dart';
import 'package:book_store/shared/circular.dart';
import 'package:book_store/shared/custom_drawer.dart';
import 'package:book_store/shared/search_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

double width = 0.0;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Color(0xff19b38d),
        title: Text("Home"),
        centerTitle: true,
        elevation: 0.5,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (c) => CartScreen()));
                },
              ),
              Positioned(
                child: Stack(
                  children: [
                    Icon(Icons.brightness_1, size: 20.0, color: Colors.red),
                    Positioned(
                      top: 3.0,
                      bottom: 4.0,
                      left: 6.0,
                      child: Consumer<CountBookOnCart>(
                        builder: (context, counter, _) {
                          return Text(
                            (BookStore.sharedPreferences!
                                        .getStringList(BookStore.userCart)!
                                        .length -
                                    1)
                                .toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegate()),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("books")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, dataSnapshot) {
              return !dataSnapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: circularProgress(),
                      ),
                    )
                  : SliverStaggeredGrid.countBuilder(
                      crossAxisCount: 2,
                      // crossAxisSpacing: 2.0,
                      staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                      itemBuilder: (context, index) {
                        BookModel bookModel = BookModel.fromJson(
                            dataSnapshot.data!.docs[index].data()
                                as Map<String, dynamic>);
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (c) => BookDetails(
                                          bookModel: bookModel,
                                        )));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
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
                                        1, 1), // shadow direction: bottom right
                                  )
                                ],
                              ),
                              height: 200.0,
                              child: GridTile(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Image.network(
                                    bookModel.bookPhotoUrl,
                                  ),
                                ),
                                footer: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white,
                                  ),
                                  height: 40,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Expanded(
                                        child: Text(
                                          bookModel.title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "\₹" +
                                                  (bookModel.price +
                                                          bookModel.price)
                                                      .toString(),
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                            Text(
                                              "\₹" + bookModel.price.toString(),
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: dataSnapshot.data!.docs.length,
                    );
            },
          ),
        ],
      ),
    );
  }
}
