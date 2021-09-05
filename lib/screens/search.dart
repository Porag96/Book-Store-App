import 'package:book_store/data_model/books.dart';
import 'package:book_store/screens/home_screen.dart';
import 'package:book_store/shared/custom_appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'book_details.dart';

class SearchBook extends StatefulWidget {
  @override
  _SearchBookState createState() => _SearchBookState();
}

class _SearchBookState extends State<SearchBook> {
  Future<QuerySnapshot>? searchList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: Text("Search"),
        bottom: PreferredSize(
          child: search(),
          preferredSize: Size(56.0, 56.0),
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: searchList,
        builder: (context, snap) {
          return snap.hasData
              ? StaggeredGridView.countBuilder(
                  crossAxisCount: 2,
                  staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                  itemCount: snap.data!.docs.length,
                  itemBuilder: (context, index) {
                    BookModel bookModel = BookModel.fromJson(
                        snap.data!.docs[index].data() as Map<String, dynamic>);

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
                                    padding: const EdgeInsets.only(right: 5.0),
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
                                              decoration:
                                                  TextDecoration.lineThrough),
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
                )
              : Center(
                  child: Text("Book Not Found !"),
                );
        },
      ),
    );
  }

  Widget search() {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 80.0,
      child: Container(
        width: MediaQuery.of(context).size.width - 40.0,
        height: 50.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          border: Border.all(color: Colors.lightBlueAccent),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Icon(Icons.search),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: TextField(
                  onChanged: (value) {
                    searchForBook(value);
                  },
                  decoration:
                      InputDecoration.collapsed(hintText: "Search here..."),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future searchForBook(String serachQuery) async {
    searchList = FirebaseFirestore.instance
        .collection("books")
        .where("title", isGreaterThanOrEqualTo: serachQuery)
        .get();
  }
}
