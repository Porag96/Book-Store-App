import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookStore {
  static String appName = 'book_Store';

  static SharedPreferences? sharedPreferences;
  static User? user;
  static FirebaseAuth? auth;
  static FirebaseFirestore? firebaseFirestore;

  static String users = "users";
  static String orders = "orders";
  static String userCart = "userCart";
  static String userAddress = "userAddress";

  static final String userName = "userName";
  static final String userEmail = "userEmail";
  static final String userDpUrl = "dpUrl";
  static final String userID = "uid";
  static final String avatarUrl = "avatarUrl";

  static final String userAddressID = "userAddressID";
  static final String totalMoney = "totalMoney";
  static final String bookID = "bookID";
  static final String payementDetails = "payementDetails";
  static final String orderTime = "orderTime";
  static final String isPlacedOrder = "isPlacedOrder";
}
