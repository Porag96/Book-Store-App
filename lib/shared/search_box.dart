import 'package:book_store/screens/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBoxDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => SearchBook()));
        },
        child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 100.0,
          child: InkWell(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                border: Border.all(color: Colors.lightBlueAccent),
              ),
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    Text(
                      "Search here...",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  @override
  double get maxExtent => 80;

  @override
  double get minExtent => 80;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
