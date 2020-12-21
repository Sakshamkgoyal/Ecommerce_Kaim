import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kaim/screens/products_screen.dart';
import 'package:kaim/services/firebase_services.dart';
import 'package:kaim/widgets/custom_action_bar.dart';


class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  FirebaseServices _firebaseServices = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          FutureBuilder<QuerySnapshot>(
            future: _firebaseServices.usersRef
                .doc(_firebaseServices.getUserId())
                .collection("Cart")
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductPage(
                                      ProductId: document.id,
                                    )));
                      },
                      child: FutureBuilder(
                        future: _firebaseServices.productsRef.doc(document.id).get(),
                        builder: (context, productSnap){

                          if(productSnap.hasError){
                            return Container(
                              child: Center(
                                child: Text("${productSnap.error}"),
                              ),
                            );
                          }

                          if(productSnap.connectionState == ConnectionState.done){
                            Map _productMap = productSnap.data.data();
                            return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                width: MediaQuery.of(context).size.height,
                                margin: EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 24,
                                ),
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 90,
                                          height: 90,
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(8.0),
                                            child: Image.network(
                                              "${_productMap['images'][0]}",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                            left: 16.0,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${_productMap['name']}",
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                  vertical: 4.0,
                                                ),
                                                child: Text(
                                                  "\$${_productMap['price']}",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                      fontWeight:
                                                      FontWeight.w600),
                                                ),
                                              ),
                                              Text(
                                                "Size - ${document.data()['size']}",
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed:(){
                                          setState(() {
                                            _firebaseServices.usersRef.doc(_firebaseServices.getUserId()).collection("Cart").doc(document.id).delete();
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                            );
                          }

                          return Container(
                            child: Center(child: CircularProgressIndicator()),
                          );

                        },
                      ),
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
          CustomActionBar(
            hasBackArrow: true,
            title: "Cart",
          )
        ],
      ),
    ));
  }
}