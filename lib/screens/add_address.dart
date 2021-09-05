import 'package:book_store/data_model/address.dart';
import 'package:book_store/screens/cart.dart';
import 'package:book_store/screens/home_screen.dart';
import 'package:book_store/service/service.dart';
import 'package:book_store/shared/custom_appbar.dart';
import 'package:flutter/material.dart';

class AddAddressScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final cName = TextEditingController();
  final cPhoneNumber = TextEditingController();
  final cHouseNumber = TextEditingController();
  final cCity = TextEditingController();
  final cState = TextEditingController();
  final cPinCode = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppbar(
        title: Text("Add Adress"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text("Save"),
        backgroundColor: Color(0xff19b38d),
        icon: Icon(Icons.check),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            final addressModel = AddressDataModel(
              name: cName.text.trim(),
              phoneNumber: cPhoneNumber.text.trim(),
              houseNumber: cHouseNumber.text.trim(),
              city: cCity.text.trim(),
              state: cState.text.trim(),
              pincode: cPinCode.text,
            ).toJson();

            //add to firebase

            BookStore.firebaseFirestore!
                .collection(BookStore.users)
                .doc(BookStore.sharedPreferences!.getString(BookStore.userID))
                .collection(BookStore.userAddress)
                .doc(DateTime.now().millisecondsSinceEpoch.toString())
                .set(addressModel)
                .then((value) {
              final snack =
                  SnackBar(content: Text("Address added Successfully."));
              ScaffoldMessenger.of(context).showSnackBar(snack);
              FocusScope.of(context).requestFocus(FocusNode());
              formKey.currentState!.reset();
            });
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (c) => CartScreen()));
          }
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Add New Address",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  SharedTextField(
                    hint: "Name",
                    controller: cName,
                  ),
                  SharedTextField(
                    hint: "Phone Number",
                    controller: cPhoneNumber,
                  ),
                  SharedTextField(
                    hint: "House/Flat Number",
                    controller: cHouseNumber,
                  ),
                  SharedTextField(
                    hint: "City",
                    controller: cCity,
                  ),
                  SharedTextField(
                    hint: "State",
                    controller: cState,
                  ),
                  SharedTextField(
                    hint: "PIN Code",
                    controller: cPinCode,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SharedTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;

  SharedTextField({this.hint, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (val) => val!.isEmpty ? "All Fields are required." : null,
      ),
    );
  }
}
