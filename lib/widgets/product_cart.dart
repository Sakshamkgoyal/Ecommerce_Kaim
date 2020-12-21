import 'package:flutter/material.dart';

import '../constants.dart';

class ProductCart extends StatelessWidget {
  final Function onPressed;
  final String imageurl;
  final String price;
  final String title;
  ProductCart({this.onPressed,this.imageurl,this.title,this.price});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        height: 350,
        width: MediaQuery.of(context).size.height,
        margin: EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 24,
        ),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.height,
              height: 350,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.network(
                  "$imageurl",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title ??
                          "No Product Name",
                      style: Constants.regularHeading,
                    ),
                    Text(
                      "₹$price" ??
                          "No Product Price",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
