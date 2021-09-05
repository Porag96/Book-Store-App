import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  String title = '';
  String authorName = '';
  String bookPhotoUrl = '';
  String category = '';
  String status = '';
  String description = '';
  Timestamp? publishedDate;
  int price = 0;

  BookModel({
    required this.title,
    required this.authorName,
    required this.bookPhotoUrl,
    required this.category,
    required this.status,
    required this.description,
    required this.publishedDate,
    required this.price,
  });

  BookModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    authorName = json['authorName'];
    bookPhotoUrl = json['bookPhotoUrl'];
    category = json['category'];
    status = json['status'];
    description = json['description'];
    publishedDate = json['publishedDate'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['title'] = this.title;
    data['authorName'] = this.authorName;
    data['bookPhotoUrl'] = this.bookPhotoUrl;
    data['category'] = this.category;
    data['status'] = this.status;
    data['description'] = this.description;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    data['price'] = this.price;
    return data;
  }
}

class PublishedDate {
  String? date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}
