import 'dart:io';

import 'package:book_store/data_model/books.dart';
import 'package:book_store/screens/home_screen.dart';
import 'package:book_store/service/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'admin_order_card.dart';

class ViewBooks extends StatefulWidget {
  @override
  _ViewBooksState createState() => _ViewBooksState();
}

class _ViewBooksState extends State<ViewBooks> {
  ImagePicker _picker = ImagePicker();
  XFile? file;
  TextEditingController _title = TextEditingController();
  TextEditingController _authorName = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _category = TextEditingController();
  String bookId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;
  @override
  Widget build(BuildContext context) {
    return file != null
        ? bookUpload()
        : Scaffold(
            floatingActionButton: FloatingActionButton.extended(
              label: Text("Add New Book"),
              icon: Icon(Icons.add),
              onPressed: () {
                selectImage(context);
              },
              backgroundColor: Colors.red,
            ),
            appBar: AppBar(
              backgroundColor: Colors.white70,
              title: Text(
                "View Books",
                style: TextStyle(color: Colors.black),
              ),
              centerTitle: true,
              elevation: 0.0,
              iconTheme: IconThemeData(
                color: Colors.lightBlueAccent,
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("books").snapshots(),
              builder: (c, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (c, index) {
                          BookModel bookModel = BookModel.fromJson(
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>);
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 5.0),
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
                              height: 160.0,
                              width: width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Image.network(
                                      bookModel.bookPhotoUrl,
                                      //width: 180.0,
                                      height: 145.0,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                          fontSize: 14.0),
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
                                                    Text(
                                                      "Category:",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.black54),
                                                    ),
                                                    SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Text(
                                                      bookModel.category,
                                                      style: TextStyle(
                                                          color: Colors.black54,
                                                          fontSize: 14.0),
                                                    ),
                                                  ],
                                                )),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 12.0,
                                          ),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 5.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "Total Price: ",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54),
                                                        ),
                                                        Text(
                                                          "₹",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54),
                                                        ),
                                                        Text(
                                                          bookModel.price
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Divider(
                                            height: 5.0,
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: circularProgress(),
                      );
              },
            ),
          );
  }

  selectImage(ctx) {
    return showDialog(
        context: ctx,
        builder: (c) {
          return SimpleDialog(
            title: Text(
              "Select Book Image",
              style:
                  TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text("Select Image from Gallery"),
                onPressed: pickBookImageFromGallery,
              ),
              SimpleDialogOption(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  pickBookImageFromGallery() async {
    Navigator.pop(context);
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = image;
    });
  }

  bookUpload() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        elevation: 0.0,
        title: Text(
          "Upload Book",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Save Book Info"),
        icon: Icon(Icons.add),
        backgroundColor: Colors.pink,
        onPressed: uploading ? null : () => uploadBookInfo(),
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(""),
          Container(
            height: 230.0,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.file(
                        File(file!.path),
                        fit: BoxFit.cover,
                      ).image,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12.0)),
          ListTile(
            leading: Icon(
              Icons.title,
              color: Colors.red,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _title,
                decoration: InputDecoration(
                  hintText: "Book Name",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.red,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _authorName,
                decoration: InputDecoration(
                  hintText: "Author Name",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(
              Icons.category,
              color: Colors.red,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _category,
                decoration: InputDecoration(
                  hintText: "Category",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(
              Icons.description,
              color: Colors.red,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _description,
                decoration: InputDecoration(
                  hintText: "Description",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            leading: Icon(
              Icons.price_change,
              color: Colors.red,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _price,
                decoration: InputDecoration(
                  hintText: "Price",
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  circularProgress() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 20.0),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.blue),
      ),
    );
  }

  uploadBookInfo() async {
    setState(() {
      uploading = true;
    });
    String imageUrl = await uploadBookImageToStorage(File(file!.path));
    saveBookInfo(imageUrl);
  }

  Future<String> uploadBookImageToStorage(bookImageFile) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference reference = storage.ref().child("Books");
    UploadTask uploadTask =
        reference.child("book_$bookId.jpg").putFile(bookImageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveBookInfo(String downloadUrl) {
    final bookRef = FirebaseFirestore.instance.collection("books");
    bookRef.doc(bookId).set({
      "authorName": _authorName.text.trim(),
      "category": _category.text.trim(),
      "description": _description.text.trim(),
      "price": int.parse(_price.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "bookPhotoUrl": downloadUrl,
      "title": _title.text.trim(),
    });

    setState(() {
      file = null;
      uploading = false;
      bookId = DateTime.now().millisecondsSinceEpoch.toString();
      _category.clear();
      _title.clear();
      _authorName.clear();
      _price.clear();
      _description.clear();
    });
  }
}
