import 'package:book_store/screens/add_address.dart';
import 'package:book_store/screens/cart.dart';
import 'package:book_store/screens/home_screen.dart';
import 'package:book_store/screens/login.dart';
import 'package:book_store/screens/my_orders.dart';
import 'package:book_store/screens/search.dart';
import 'package:book_store/service/service.dart';
import 'package:book_store/shared/about.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
            color: Color(0xff19b38d),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  elevation: 8.0,
                  child: Container(
                    height: 130.0,
                    width: 130.0,
                    child: CircleAvatar(
                      backgroundColor: Color(0xff19b38d),
                      backgroundImage: NetworkImage(
                        BookStore.sharedPreferences!
                            .getString(BookStore.avatarUrl) as String,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  BookStore.sharedPreferences!.getString(BookStore.userName)
                      as String,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Signatra"),
                ),
                Text(
                  BookStore.sharedPreferences!.getString(BookStore.userEmail)
                      as String,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 1.0),
            color: Colors.white10,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.blueGrey,
                  ),
                  title: Text(
                    "Home",
                    style: TextStyle(color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (c) => HomeScreen()));
                  },
                ),
                Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_basket,
                    color: Colors.blueGrey,
                  ),
                  title: Text(
                    "My Orders",
                    style: TextStyle(color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (c) => MyOrders()));
                  },
                ),
                Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.blueGrey,
                  ),
                  title: Text(
                    "My Cart",
                    style: TextStyle(color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (c) => CartScreen()));
                  },
                ),
                Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.blueGrey,
                  ),
                  title: Text(
                    "Search",
                    style: TextStyle(color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (c) => SearchBook()));
                  },
                ),
                Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  leading: Icon(
                    Icons.contact_mail,
                    color: Colors.blueGrey,
                  ),
                  title: Text(
                    "Add New Address",
                    style: TextStyle(color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (c) => AddAddressScreen()));
                  },
                ),
                Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  leading: Icon(
                    Icons.info,
                    color: Colors.blueGrey,
                  ),
                  title: Text(
                    "About",
                    style: TextStyle(color: Colors.black87),
                  ),
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (c) => About()));
                  },
                ),
                Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.blueGrey,
                  ),
                  title: Text(
                    "Logout",
                    style: TextStyle(color: Colors.black87),
                  ),
                  onTap: () {
                    BookStore.auth!.signOut().then((c) {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (c) => Login()));
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
