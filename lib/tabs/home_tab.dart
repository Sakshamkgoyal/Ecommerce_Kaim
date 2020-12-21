import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaim/screens/products_screen.dart';
import 'package:kaim/widgets/custom_action_bar.dart';
import 'package:kaim/widgets/product_cart.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final CollectionReference _productsRef =
      FirebaseFirestore.instance.collection("Products");

  int LoadLength = 3;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _productsRef
                .orderBy("search_string", descending: false)
                .limitToLast(LoadLength)
                .get(),
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
                return ListView(
                  padding: EdgeInsets.only(
                    top: 100,
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
            padding: const EdgeInsets.all(13.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    LoadLength += 3;
                  });
                },
                child: Icon(
                  Icons.add_circle
                ),
              ),
            ),
          ),
          Container(
            child: CustomActionBar(
              hasBackArrow: false,
              title: "Home",
              hasTitile: true,
            ),
          ),
        ],
      ),
    );
  }
}
