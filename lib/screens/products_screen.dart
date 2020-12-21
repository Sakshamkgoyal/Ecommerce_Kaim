import 'package:flutter/material.dart';
import 'package:kaim/constants.dart';
import 'package:kaim/services/firebase_services.dart';
import 'package:kaim/widgets/custom_action_bar.dart';
import 'package:kaim/widgets/image_swipe.dart';
import 'package:kaim/widgets/product_size.dart';

class ProductPage extends StatefulWidget {
  final String ProductId;

  ProductPage({this.ProductId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  FirebaseServices _firebaseServices = FirebaseServices();



  String _selectedProductSize = "0";

  Future _addToCart() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Cart")
        .doc(widget.ProductId)
        .set({"size": _selectedProductSize});
  }

  Future _addToSaved() {
    return _firebaseServices.usersRef
        .doc(_firebaseServices.getUserId())
        .collection("Saved")
        .doc(widget.ProductId)
        .set({"size": _selectedProductSize});
  }


  final SnackBar _snackBar = SnackBar(content: Text("Product added to cart"),);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          FutureBuilder(
            future: _firebaseServices.productsRef.doc(widget.ProductId).get(),
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
                Map<String, dynamic> documentData = snapshot.data.data();
                List imageList = documentData['images'];
                List productSizes = documentData['size'];

                //Set an initial size
                _selectedProductSize = productSizes[0];
                return ListView(
                  padding: EdgeInsets.all(0),
                  children: [
                    ImageSwipe(
                      imageList: imageList,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 24),
                      child: Text(
                        documentData['name'] ?? "Product Name",
                        style: Constants.boldHeading,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 24),
                      child: Text(
                        "₹ ${documentData['price']}" ?? "Price",
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 24),
                      child: Text(
                        documentData['desc'] ?? "Description",
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 24),
                      child: Text(
                        "Select Size",
                        style: Constants.regularDarkText,
                      ),
                    ),
                    ProductSize(
                      productSizes: productSizes,
                      onSelected: (size){
                        _selectedProductSize = size;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await _addToSaved();
                              Scaffold.of(context).showSnackBar(SnackBar(content: Text("Product Saved for future"),));
                            },
                            child: Container(
                                width: 65,
                                height: 65,
                                decoration: BoxDecoration(
                                  color: Color(0xffDCDCDC),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.bookmark_border,
                                  size: 21,
                                )),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await _addToCart();
                                Scaffold.of(context).showSnackBar(_snackBar);
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 16),
                                height: 65,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
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
            hasBackground: false,
            hasBackArrow: true,
            hasTitile: false,
          )
        ],
      )),
    );
  }
}
