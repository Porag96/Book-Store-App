import 'package:book_store/providers/count_book_on_cart.dart';
import 'package:book_store/screens/cart.dart';
import 'package:book_store/service/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppbar extends StatelessWidget with PreferredSizeWidget {
  final PreferredSizeWidget? bottom;
  final Widget title;
  CustomAppbar({this.bottom, required this.title});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: Color(0xff19b38d),
      title: title,
      centerTitle: true,
      bottom: bottom,
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
    );
  }

  Size get preferredSize => bottom == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}
