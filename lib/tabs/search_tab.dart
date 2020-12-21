import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaim/constants.dart';
import 'package:kaim/screens/products_screen.dart';
import 'package:kaim/services/firebase_services.dart';
import 'package:kaim/widgets/custom_input.dart';
import 'package:kaim/widgets/product_cart.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  FirebaseServices _firebaseServices = FirebaseServices();

  String _searchString = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Stack(
          children: [
            FutureBuilder<QuerySnapshot>(
              future: _firebaseServices.productsRef
                  .orderBy("search_string")
                  .startAt([_searchString]).endAt(
                      ["$_searchString\uf8ff"]).get(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Scaffold(
                    body: Container(
                      child: Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                        ),
                      ),
                    ),
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (_searchString.isEmpty) {
                    return Center(
                      child: Container(
                          child: Text(
                        "Add text to Search...",
                        style: Constants.regularDarkText,
                      )),
                    );
                  } else {
                    return ListView(
                      padding: EdgeInsets.only(
                        top: 120,
                        bottom: 24.0,
                      ),
                      children: snapshot.data.docs.map((document) {
                        return ProductCart(
                          title: document.data()['name'],
                          imageurl: document.data()['images'][0],
                          price: document.data()['price'],
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductPage(ProductId: document.id)));
                          },
                        );
                      }).toList(),
                    );
                  }
                }

                return Scaffold(
                  body: Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 45),
              child: CustomInput(
                hintText: "Search Here....",
                onChnaged: (value) {
                  setState(() {
                    _searchString = value.toLowerCase();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
